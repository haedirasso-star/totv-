import 'package:equatable/equatable.dart';

/// Failures - Core Layer
/// الـ Failure هو الطريقة التي ننقل بها الخطأ من طبقة البيانات إلى طبقة الواجهات.
/// نستخدم Equatable لضمان أن الـ Bloc يعرف إذا كان الخطأ قد تغير فعلاً أم لا.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// فشل ناتج عن خطأ من السيرفر أو الـ API
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// فشل ناتج عن عدم وجود اتصال بالإنترنت
class NetworkFailure extends Failure {
  const NetworkFailure() : super('لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة وإعادة المحاولة.');
}

/// فشل ناتج عن خطأ في قاعدة البيانات المحلية
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// فشل ناتج عن انتهاء صلاحية الرابط (مهم جداً لروابط JADX)
class LinkExpiredFailure extends Failure {
  const LinkExpiredFailure() : super('انتهت صلاحية رابط البث، جاري محاولة التحديث...');
}

/// فشل ناتج عن محتوى محظور جغرافياً أو غير مصرح به
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('عذراً، هذا المحتوى غير متوفر في منطقتك أو يتطلب اشتراكاً.');
}

/// فشل ناتج عن خطأ في فك التشفير (عند التعامل مع سيرفرات محمية)
class DecryptionFailure extends Failure {
  const DecryptionFailure() : super('حدث خطأ أثناء معالجة بيانات البث المباشر.');
}
