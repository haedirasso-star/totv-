/// Exceptions - Core Layer
/// هذا الملف يحتوي على كافة أنواع الاستثناءات (الأخطاء) التي قد تحدث في الطبقات الدنيا (Data Layer)

/// استثناء خاص بأخطاء السيرفر (API, Database, M3U Link)
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});

  @override
  String toString() => message ?? "حدث خطأ في الاتصال بالسيرفر";
}

/// استثناء خاص بفشل الاتصال بالإنترنت (Network Timeout, No Connection)
class NetworkException implements Exception {
  final String message;

  NetworkException({this.isSelected, this.message = "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة"});
  
  final bool? isSelected;
}

/// استثناء خاص بأخطاء التشفير أو فك التشفير (مهم جداً للهندسة العكسية و JADX)
class DecryptionException implements Exception {
  final String message;

  DecryptionException({this.message = "فشل في فك تشفير رابط البث"});
}

/// استثناء خاص بالصلاحيات (403 Forbidden أو انتهت صلاحية التوكن)
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({this.message = "غير مصرح لك بالوصول لهذا المحتوى"});
}

/// استثناء خاص بانتهاء صلاحية رابط البث (Expired Link)
class LinkExpiredException implements Exception {
  final String message;

  LinkExpiredException({this.message = "انتهت صلاحية رابط التشغيل، يرجى التحديث"});
}

/// استثناء عام لأي خطأ غير متوقع
class UnexpectedException implements Exception {
  final String message;

  UnexpectedException({this.message = "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"});
}
