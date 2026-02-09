import 'package:dio/dio.dart';
import '../models/content_model.dart';
import '../../domain/entities/content.dart';
import '../../core/error/exceptions.dart';

abstract class MovieRemoteDataSource {
  Future<List<ContentModel>> getMovies({int page = 1});
  Future<List<ContentModel>> getSeries({int page = 1});
  Future<List<ContentModel>> searchMovies(String query);
  Future<ContentModel> getMovieDetails(String id);
  Future<StreamingUrlModel> refreshUrl(String contentId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;
  final String apiKey = '5b166a24c91f59178e8ce30f1f3735c0';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ContentModel>> getMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '$baseUrl/movie/popular',
        queryParameters: {
          'api_key': apiKey,
          'language': 'ar-SA',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => _mapToContentModel(json, ContentType.movie)).toList();
      } else {
        throw ServerException(message: 'فشل جلب الأفلام من TMDB');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ContentModel>> getSeries({int page = 1}) async {
    try {
      final response = await dio.get(
        '$baseUrl/tv/popular',
        queryParameters: {
          'api_key': apiKey,
          'language': 'ar-SA',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => _mapToContentModel(json, ContentType.series)).toList();
      } else {
        throw ServerException(message: 'فشل جلب المسلسلات');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ContentModel>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        '$baseUrl/search/multi',
        queryParameters: {
          'api_key': apiKey,
          'language': 'ar-SA',
          'query': query,
        },
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results
            .where((json) => json['media_type'] == 'movie' || json['media_type'] == 'tv')
            .map((json) {
          final type = json['media_type'] == 'movie' ? ContentType.movie : ContentType.series;
          return _mapToContentModel(json, type);
        }).toList();
      } else {
        throw ServerException(message: 'فشل عملية البحث');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ContentModel> getMovieDetails(String id) async {
    try {
      final response = await dio.get(
        '$baseUrl/movie/$id',
        queryParameters: {
          'api_key': apiKey,
          'language': 'ar-SA',
        },
      );

      if (response.statusCode == 200) {
        return _mapToContentModel(response.data, ContentType.movie);
      } else {
        throw ServerException(message: 'فشل جلب تفاصيل الفيلم');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<StreamingUrlModel> refreshUrl(String contentId) async {
    // ملاحظة: TMDB لا يوفر روابط بث مباشرة (فيديو)، هو يوفر معلومات فقط.
    // هنا يمكن ربط سيرفر خارجي (مثل VidSrc) لجلب روابط المشغل لاحقاً.
    return const StreamingUrlModel(
      url: '', // سيتم تحديث هذا عند ربط سيرفر الفيديو
      quality: 'HD',
    );
  }

  /// دالة تحويل بيانات TMDB إلى الموديل الخاص بنا
  ContentModel _mapToContentModel(Map<String, dynamic> json, ContentType type) {
    return ContentModel(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'بدون عنوان',
      description: json['overview'],
      imageUrl: json['backdrop_path'] != null ? '$imageBaseUrl${json['backdrop_path']}' : null,
      posterUrl: json['poster_url'] != null ? '$imageBaseUrl${json['poster_path']}' : null,
      type: type,
      rating: (json['vote_average'] as num?)?.toDouble(),
      year: _parseYear(json['release_date'] ?? json['first_air_date']),
      isLive: false,
      metadata: json,
    );
  }

  int? _parseYear(dynamic date) {
    if (date == null || date.toString().isEmpty) return null;
    return DateTime.tryParse(date.toString())?.year;
  }
}
