import 'package:equatable/equatable.dart';

/// Base Failure Class
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Server Failure
class ServerFailure extends Failure {
  const ServerFailure([String message = 'حدث خطأ في الخادم'])
      : super(message);
}

/// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure([String message = 'حدث خطأ في التخزين المؤقت'])
      : super(message);
}

/// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'لا يوجد اتصال بالإنترنت'])
      : super(message);
}

/// Parsing Failure
class ParsingFailure extends Failure {
  const ParsingFailure([String message = 'خطأ في معالجة البيانات'])
      : super(message);
}

/// Authentication Failure
class AuthFailure extends Failure {
  const AuthFailure([String message = 'خطأ في المصادقة'])
      : super(message);
}

/// Not Found Failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'المحتوى غير موجود'])
      : super(message);
}

/// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'حدث خطأ غير معروف'])
      : super(message);
}
