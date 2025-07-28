import 'package:chat_app_user/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:chat_app_user/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:chat_app_user/features/theme/domain/repositories/theme_repository.dart';
import 'package:chat_app_user/features/theme/domain/usecases/get_theme_usecase.dart';
import 'package:chat_app_user/features/theme/domain/usecases/save_theme_usecase.dart';
import 'package:chat_app_user/features/user/domain/repositories/user_repository.dart';
import 'package:chat_app_user/shared/services/storage/secure_storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'core/navigation/bloc/navigation_bloc.dart';
import 'core/network/dio_client.dart';
import 'core/network/socket_io_client.dart';
import 'core/offline/database/local_data_base.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chat/data/datasources/chat_local_datasource.dart';
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/delete_message.dart';
import 'features/chat/domain/usecases/get_chat_room.dart';
import 'features/chat/domain/usecases/get_messages.dart';
import 'features/chat/domain/usecases/mark_as_read.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/bloc/chat_list_bloc.dart';
import 'features/theme/presentation/theme_bloc.dart';
import 'features/user/data/dataources/user_local_data_source.dart';
import 'features/user/data/dataources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/usecases/get_user_details_use_case.dart';
import 'features/user/domain/usecases/get_users_use_case.dart';
import 'features/user/presentation/bloc/user_list_bloc.dart';

final sl = GetIt.instance;

Future<void> init(AppEnvironment environment) async {
  await _initCore(environment);
  await _initAuth();
  await _initTheme();
  await _initChat();
  await _navigation();
  await _initUser();
}

Future<void> _navigation() async {
  sl.registerLazySingleton(() => NavigationBloc());
}

Future<void> _initCore(AppEnvironment environment) async {
  // Register SecureStorageService (used by DioClient and others)
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Register DioClient with SecureStorageService
  sl.registerLazySingleton<DioClient>(
    () => DioClient(storage: sl(), environment: environment),
  );

  //Register DatabaseService
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());

  sl.registerLazySingleton<IoClient>(
    () => IoClient(
      storage: sl<SecureStorageService>(),
      environment: AppConfig.environment,
    ),
  );
}

Future<void> _initUser() async {
  // Data source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );
  // Local data source
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
      localDataSource: sl<UserLocalDataSource>(),
    ),
  );

  // Use cases
  // sl.registerLazySingleton(() => GetUserByIdUseCase(sl()));
  // sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  // sl.registerLazySingleton(() => SearchUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserDetailsUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl<UserRepository>()));

  //Bloc
  sl.registerFactory(
    () => UserListBloc(getUsersUseCase: sl<GetUsersUseCase>()),
  );
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

Future<void> _initChat() async {
  // Data source
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      ioClient: sl<IoClient>(),
    ),
  );
  // Local data source
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(databaseService: sl<DatabaseService>()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl<ChatRemoteDataSource>(),
      localDataSource: sl<ChatLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMessageUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => GetChatRoomsUseCase(sl()));

  //Bloc
  sl.registerFactory(
    () => ChatBloc(
      sendMessageUseCase: sl(),
      getMessagesUseCase: sl(),
      deleteMessageUseCase: sl(),
      markAsReadUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ChatListBloc(getChatRoomsUseCase: sl()));
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
