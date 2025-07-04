import 'package:chat_app_user/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:chat_app_user/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:chat_app_user/features/theme/domain/repositories/theme_repository.dart';
import 'package:chat_app_user/features/theme/domain/usecases/get_theme_usecase.dart';
import 'package:chat_app_user/features/theme/domain/usecases/save_theme_usecase.dart';
import 'package:chat_app_user/shared/services/storage/secure_storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/theme/presentation/theme_bloc.dart';

final sl = GetIt.instance;

Future<void> init(AppEnvironment environment) async {
  await _initCore(environment);
  await _initAuth();
  await _initTheme();
}

Future<void> _initCore(AppEnvironment environment) async {
  // Register SecureStorageService (used by DioClient and others)
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Register DioClient with SecureStorageService
  sl.registerLazySingleton<DioClient>(() => DioClient(storage: sl()));
}

Future<void> _initAuth() async {
  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      networkClient: sl<DioClient>(),
      secureStorage: sl<SecureStorageService>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatus: sl(),
      getCurrentUser: sl(),
      login: sl(),
      register: sl(),
      logout: sl(),
    ),
  );
}

Future<void> _initTheme() async {
  // Local data source
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => ThemeBloc(getThemeUseCase: sl(), saveThemeUseCase: sl()),
  );
}
