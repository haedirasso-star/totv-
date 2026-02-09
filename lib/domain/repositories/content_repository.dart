import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/content.dart';

/// Content Repository - Domain Layer (Contract)
/// هذا هو "العقد" الذي يحدد العمليات المتاحة في التطبيق.
/// نستخدم [Either] لإرجاع [Failure] في حالة الخطأ أو [List<Content>] في حالة النجاح.
abstract class ContentRepository {
  
  /// جلب كافة القنوات المباشرة
  Future<Either<Failure, List<Content>>> getLiveChannels();

  /// جلب الأفلام المتاحة
  Future<Either<Failure, List<Content>>> getMovies();

  /// جلب المسلسلات
  Future<Either<Failure, List<Content>>> getSeries();

  /// جلب المحتوى المخصص حسب التصنيف (مثل: رياضة، أطفال)
  Future<Either<Failure, List<Content>>> getContentByCategory(String category);

  /// البحث في المحتوى (قنوات، أفلام، مسلسلات)
  Future<Either<Failure, List<Content>>> searchContent(String query);

  /// جلب تفاصيل محتوى معين باستخدام المعرف (ID)
  Future<Either<Failure, Content>> getContentDetails(String id);

  /// تحديث حالة البث (مفيد عند التعامل مع روابط JADX التي قد تتوقف)
  Future<Either<Failure, StreamingUrl>> refreshStreamingUrl(String contentId);
}
