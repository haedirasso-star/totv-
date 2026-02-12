import 'package:dartz/dartz.dart';
import '../entities/content.dart';
import '../../core/error/failures.dart';

/// Content Repository Interface
/// يحدد العمليات المطلوبة من مصدر البيانات
abstract class ContentRepository {
  /// جلب قائمة القنوات المباشرة
  Future<Either<Failure, List<Content>>> getLiveChannels();
  
  /// جلب قائمة الأفلام
  Future<Either<Failure, List<Content>>> getMovies({
    int page = 1,
    String? genre,
    String? searchQuery,
  });
  
  /// جلب تفاصيل محتوى معين
  Future<Either<Failure, Content>> getContentDetails(String id);
  
  /// البحث في المحتوى
  Future<Either<Failure, List<Content>>> searchContent(String query);
  
  /// جلب المحتوى حسب الفئة
  Future<Either<Failure, List<Content>>> getContentByCategory(String category);
  
  /// جلب المحتوى المميز
  Future<Either<Failure, List<Content>>> getFeaturedContent();
  
  /// تحديث قائمة القنوات من Remote Config
  Future<Either<Failure, void>> updateChannelsFromRemoteConfig();
  
  /// جلب الإعدادات من Remote Config
  Future<Either<Failure, Map<String, dynamic>>> getRemoteConfig();
}
