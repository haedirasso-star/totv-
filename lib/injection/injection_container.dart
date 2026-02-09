import 'package:get_it/get_it.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../core/services/firebase_remote_config_service.dart';
import '../data/repositories/content_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  sl.registerLazySingleton(() => FirebaseRemoteConfigService(remoteConfig));
  
  // Repository
  sl.registerLazySingleton(() => ContentRepositoryImpl(sl()));
}