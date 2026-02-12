import 'package:dio/dio.dart';
import '../../domain/entities/content.dart';
import '../../core/services/firebase_remote_config_service.dart';

/// Movie Remote Data Source
/// يتعامل مع API الأفلام
class MovieRemoteDataSource {
  final Dio dio;
  final FirebaseRemoteConfigService remoteConfig;
  
  // API Key الافتراضي
  static const String _defaultApiKey = '5b166a24c91f59178e8ce30f1f3735c0';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  
  MovieRemoteDataSource({
    required this.dio,
    required this.remoteConfig,
  });
  
  /// الحصول على API Key من Remote Config أو استخدام الافتراضي
  String get _apiKey {
    final key = remoteConfig.getMovieApiKey();
    return key.isNotEmpty ? key : _defaultApiKey;
  }
  
  /// جلب قائمة الأفلام
  Future<List<Content>> getMovies({
    int page = 1,
    String? genre,
    String? searchQuery,
  }) async {
    try {
      String endpoint;
      Map<String, dynamic> queryParams = {
        'api_key': _apiKey,
        'language': 'ar',
        'page': page,
      };
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        endpoint = '/search/movie';
        queryParams['query'] = searchQuery;
      } else if (genre != null) {
        endpoint = '/discover/movie';
        queryParams['with_genres'] = genre;
      } else {
        endpoint = '/movie/popular';
      }
      
      final response = await dio.get(
        '$_baseUrl$endpoint',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => _mapToContent(json)).toList();
      } else {
        throw Exception('فشل في جلب الأفلام');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }
  
  /// جلب تفاصيل فيلم محدد
  Future<Content> getMovieDetails(String movieId) async {
    try {
      final response = await dio.get(
        '$_baseUrl/movie/$movieId',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'ar',
          'append_to_response': 'videos,credits',
        },
      );
      
      if (response.statusCode == 200) {
        return _mapToContent(response.data);
      } else {
        throw Exception('فشل في جلب تفاصيل الفيلم');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }
  
  /// جلب أفلام مميزة
  Future<List<Content>> getTrendingMovies() async {
    try {
      final response = await dio.get(
        '$_baseUrl/trending/movie/week',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'ar',
        },
      );
      
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => _mapToContent(json)).toList();
      } else {
        throw Exception('فشل في جلب الأفلام المميزة');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }
  
  /// جلب الأنواع
  Future<List<Map<String, dynamic>>> getGenres() async {
    try {
      final response = await dio.get(
        '$_baseUrl/genre/movie/list',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'ar',
        },
      );
      
      if (response.statusCode == 200) {
        return (response.data['genres'] as List)
            .cast<Map<String, dynamic>>();
      } else {
        throw Exception('فشل في جلب الأنواع');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }
  
  /// تحويل JSON إلى Content
  Content _mapToContent(Map<String, dynamic> json) {
    final imageBase = 'https://image.tmdb.org/t/p/w500';
    final posterBase = 'https://image.tmdb.org/t/p/original';
    
    return Content(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'بدون عنوان',
      description: json['overview'],
      imageUrl: json['poster_path'] != null 
          ? '$imageBase${json['poster_path']}' 
          : null,
      posterUrl: json['backdrop_path'] != null 
          ? '$posterBase${json['backdrop_path']}' 
          : null,
      type: ContentType.movie,
      isLive: false,
      rating: (json['vote_average'] as num?)?.toDouble(),
      year: json['release_date'] != null 
          ? int.tryParse(json['release_date'].toString().substring(0, 4))
          : null,
      genres: json['genres'] != null
          ? (json['genres'] as List)
              .map((g) => g['name'].toString())
              .toList()
          : null,
      metadata: json,
    );
  }
}
