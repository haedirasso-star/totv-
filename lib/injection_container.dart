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
  //! 1. Presentation Layer (Bloc)
  sl.registerFactory(() => ContentBloc(repository: sl()));

  //! 2. Domain Layer (Repositories)
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteConfig: sl(),
      m3uParser: sl(),
      movieDataSource: sl(),
      dio: sl(),
    ),
  );

  //! 3. Data Sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  //! 4. Core Services
  sl.registerLazySingleton(() => M3UParserService());
  sl.registerLazySingleton(() => FirebaseRemoteConfigService(sl()));

  //! 5. External Plugins (المكتبات الخارجية)
  
  // تهيئة Firebase Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  sl.registerLazySingleton(() => remoteConfig);

  // تهيئة Dio لعمليات الـ HTTP
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  ));

  // تهيئة SharedPreferences (اختياري للإعدادات المحلية)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
