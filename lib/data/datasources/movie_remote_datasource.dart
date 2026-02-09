import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser; // تأكد من إضافة html في pubspec.yaml
import '../models/content_model.dart';
import '../../domain/entities/content.dart';
import '../../core/error/exceptions.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;
  // سنبقي على TMDB لجلب صور عالية الجودة ومعلومات دقيقة
  final String apiKey = '5b166a24c91f59178e8ce30f1f3735c0';
  final String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  
  // رابط فودو الأساسي
  final String voduBaseUrl = 'https://movie.vodu.me';

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ContentModel>> getMovies({int page = 1}) async {
    try {
      // 1. نجلب الأفلام التريند من TMDB لضمان واجهة فخمة
      final response = await dio.get('$tmdbBaseUrl/movie/popular', queryParameters: {
        'api_key': apiKey,
        'language': 'ar-SA',
        'page': page,
      });

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => _mapToContentModel(json, ContentType.movie)).toList();
      } else {
        throw ServerException(message: 'فشل الاتصال');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // الدالة السحرية: جلب رابط الفيديو من فودو ديناميكياً
  @override
  Future<StreamingUrlModel> refreshUrl(String contentTitle) async {
    try {
      // 1. البحث عن الفيلم في موقع فودو باستخدام الاسم
      final searchResponse = await dio.get('$voduBaseUrl/index.php', queryParameters: {
        's': contentTitle, // البحث باسم الفيلم
      });

      var document = parser.parse(searchResponse.data);
      // البحث عن أول نتيجة في الموقع
      var firstResult = document.querySelector('.item a, .movie-item a');
      String? moviePageLink = firstResult?.attributes['href'];

      if (moviePageLink != null) {
        // 2. الدخول لصفحة الفيلم لاستخراج رابط المشغل
        final moviePageResponse = await dio.get(moviePageLink);
        var movieDoc = parser.parse(moviePageResponse.data);
        
        // استخراج رابط الـ Iframe أو رابط الفيديو المباشر
        var videoElement = movieDoc.querySelector('iframe, video source');
        String? finalUrl = videoElement?.attributes['src'] ?? videoElement?.attributes['data-src'];

        return StreamingUrlModel(
          url: finalUrl ?? '', 
          quality: 'HD',
        );
      }
    } catch (e) {
      print("Vodu Scraper Error: $e");
    }
    
    return const StreamingUrlModel(url: '', quality: 'Auto');
  }

  // ... ابقِ على بقية الدوال (getSeries, searchMovies) كما هي
  
  ContentModel _mapToContentModel(Map<String, dynamic> json, ContentType type) {
    return ContentModel(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'بدون عنوان',
      description: json['overview'],
      imageUrl: json['backdrop_path'] != null ? '$imageBaseUrl${json['backdrop_path']}' : null,
      posterUrl: json['poster_path'] != null ? '$imageBaseUrl${json['poster_path']}' : null,
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
