import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

// استيراد الطبقات الخاصة بنا
import 'core/services/firebase_remote_config_service.dart';
import 'core/services/m3u_parser_service.dart';
import 'data/datasources/movie_remote_datasource.dart';
import 'data/repositories/content_repository_impl.dart';
import 'domain/repositories/content_repository.dart';
import 'presentation/bloc/content_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! 5. External Plugins (نبدأ بها أولاً لضمان جاهزيتها)
  
  // تهيئة SharedPreferences مع حماية
  try {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  } catch (e) {
    print("Error initializing SharedPreferences: $e");
  }

  // تهيئة Dio مع إعدادات احترافية لسحب محتوى فودو
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      // إضافة Header ليوهم المواقع (مثل فودو) أن الطلب من متصفح حقيقي
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    ),
  ));

  // تهيئة Firebase Remote Config
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    sl.registerLazySingleton(() => remoteConfig);
  } catch (e) {
    print("Remote Config Error: $e");
  }

  //! 4. Core Services
  sl.registerLazySingleton(() => M3UParserService());
  sl.registerLazySingleton(() => FirebaseRemoteConfigService(sl()));

  //! 3. Data Sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    // هنا سنقوم بتعديل الـ DataSource لاحقاً ليسحب من https://movie.vodu.me/index.php
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  //! 2. Domain Layer (Repositories)
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteConfig: sl(),
      m3uParser: sl(),
      movieDataSource: sl(),
      dio: sl(),
    ),
  );

  //! 1. Presentation Layer (Bloc)
  sl.registerFactory(() => ContentBloc(repository: sl()));
}
