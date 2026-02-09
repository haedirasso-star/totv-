import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/content_model.dart';
import '../../core/error/exceptions.dart';

/// واجهة المصدر الخارجي للبيانات
abstract class RemoteDataSource {
  /// جلب القنوات المباشرة
  Future<List<ContentModel>> getLiveChannels();
  
  /// جلب الأفلام
  Future<List<ContentModel>> getMovies();
  
  /// جلب المحتوى حسب التصنيف (رياضة، أفلام، إلخ)
  Future<List<ContentModel>> getContentByCategory(String category);

  /// البحث عن محتوى
  Future<List<ContentModel>> searchContent(String query);
}

/// التنفيذ الفعلي للمحرك باستخدام مكتبة Dio
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({required this.dio}) {
    // إعدادات افتراضية لـ Dio لعام 2026
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  @override
  Future<List<ContentModel>> getLiveChannels() async {
    try {
      // هنا سنضع رابط الـ API الخاص بك أو رابط ملف الـ JSON/M3U
      // كمثال سنستخدم رابطاً تجريبياً، وسنقوم بتحديثه لاحقاً بروابط JADX
      final response = await dio.get('/api/v1/channels/live');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل جلب القنوات من السيرفر');
      }
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  @override
  Future<List<ContentModel>> getMovies() async {
    try {
      final response = await dio.get('/api/v1/movies');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل جلب قائمة الأفلام');
      }
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<List<ContentModel>> getContentByCategory(String category) async {
    try {
      final response = await dio.get(
        '/api/v1/content',
        queryParameters: {'category': category},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل جلب محتوى التصنيف: $category');
      }
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  @override
  Future<List<ContentModel>> searchContent(String query) async {
    try {
      final response = await dio.get(
        '/api/v1/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل عملية البحث');
      }
    } on DioException catch (e) {
      throw ServerException(message: _handleDioError(e));
    }
  }

  /// دالة احترافية للتعامل مع أخطاء Dio
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهت مهلة الاتصال بالسيرفر';
      case DioExceptionType.sendTimeout:
        return 'فشل إرسال الطلب للسيرفر';
      case DioExceptionType.receiveTimeout:
        return 'السيرفر استغرق وقتاً طويلاً للرد';
      case DioExceptionType.badResponse:
        return 'خطأ من السيرفر: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'حدث خطأ في الاتصال بالشبكة';
    }
  }
}
