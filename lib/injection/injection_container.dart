import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/network/network_info.dart';
import '../core/network/dio_client.dart';
import '../core/services/firebase_remote_config_service.dart';
import '../core/services/m3u_parser_service.dart';
import '../core/services/video_player_service.dart';
import '../data/datasources/movie_remote_datasource.dart';
import '../data/repositories/content_repository_impl.dart';
import '../domain/repositories/content_repository.dart';
import '../domain/usecases/get_live_channels.dart';
import '../domain/usecases/get_movies.dart';
import '../domain/usecases/search_content.dart';
import '../presentation/bloc/content_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => Connectivity());
  
  // Core - Network
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl()),
  );
  
  // Services
  sl.registerLazySingleton<FirebaseRemoteConfigService>(
    () => FirebaseRemoteConfigService(sl()),
  );
  
  sl.registerLazySingleton<M3UParserService>(
    () => M3UParserService(),
  );
  
  sl.registerFactory<VideoPlayerService>(
    () => VideoPlayerService(),
  );
  
  // Data Sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSource(
      dio: sl(),
      remoteConfig: sl(),
    ),
  );
  
  // Repositories
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      m3uParser: sl(),
      remoteConfig: sl(),
      movieDataSource: sl(),
    ),
  );
  
  // Use Cases
  sl.registerLazySingleton(() => GetLiveChannelsUseCase(sl()));
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => SearchContentUseCase(sl()));
  
  // BLoC
  sl.registerFactory(
    () => ContentBloc(repository: sl()),
  );
  
  // Initialize Firebase Remote Config
  await sl<FirebaseRemoteConfigService>().initialize();
}
