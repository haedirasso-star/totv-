import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

// Core & Services
import 'core/services/firebase_remote_config_service.dart';
import 'core/services/m3u_parser_service.dart';

// Data Sources
import 'data/datasources/movie_remote_datasource.dart';
import 'data/datasources/remote_data_source.dart';

// Repositories
import 'domain/repositories/content_repository.dart';
import 'data/repositories/content_repository_impl.dart';

// Bloc
import 'presentation/bloc/content_bloc.dart';

final sl = GetIt.instance; // sl تعني Service Locator

Future<void> init() async {
  // -------------------------------------------------------------------------
  // 1. Presentation Layer (Bloc)
  // -------------------------------------------------------------------------
  // نستخدم registerFactory لأننا نريد نسخة جديدة من الـ Bloc في كل مرة تفتح فيها الصفحة
  sl.registerFactory(() => ContentBloc(repository: sl()));

  // -------------------------------------------------------------------------
  // 2. Domain Layer (Repositories)
  // -------------------------------------------------------------------------
  // هنا نربط الـ Interface بالـ Implementation الفعلي
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      m3uParser: sl(),
      remoteConfig: sl(),
      movieDataSource: sl(),
    ),
  );

  // -------------------------------------------------------------------------
  // 3. Data Layer (Data Sources)
  // -------------------------------------------------------------------------
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );
  
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(dio: sl()),
  );

  // -------------------------------------------------------------------------
  // 4. Core Services (M3U Parser, Firebase Config)
  // -------------------------------------------------------------------------
  sl.registerLazySingleton(() => M3UParserService());
  
  // تهيئة Firebase Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  final remoteConfigService = FirebaseRemoteConfigService(remoteConfig);
  // مهم: نقوم بتهيئة الخدمة قبل تسجيلها لضمان جاهزية البيانات
  await remoteConfigService.initialize();
  sl.registerLazySingleton(() => remoteConfigService);

  // -------------------------------------------------------------------------
  // 5. External Libraries (Dio, Firebase, etc.)
  // -------------------------------------------------------------------------
  // تسجيل Dio مع إعدادات افتراضية قوية لعام 2026
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'X-App-Version': '2026.1.0',
        },
      ),
    );
    // يمكن إضافة Interceptors هنا لتصحيح الأخطاء تلقائياً
    return dio;
  });
}
