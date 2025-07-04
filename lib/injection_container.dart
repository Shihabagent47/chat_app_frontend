import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:chat_app_user/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:chat_app_user/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_app_user/features/auth/domain/repositories/auth_repository.dart';
import 'package:chat_app_user/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'config/app_config.dart';

final sl = GetIt.instance;

// Future<void> init(AppConfig config) async {
//   //! Features
//   await _initAuth();
//
//   //! Core
//   await _initCore(config);
//
//   //! External
//   await _initExternal(config);
// }
//
// Future<void> _initCore(AppConfig config) async {
//   // Network
//   sl.registerLazySingleton<Dio>(() {
//     final dio = Dio();
//
//     // Add interceptors based on config
//     if (config.environment.enableLogging) {
//       dio.interceptors.add(
//         LogInterceptor(requestBody: true, responseBody: true),
//       );
//     }
//
//     dio.options = BaseOptions(
//       baseUrl: config.environment.baseUrl,
//       connectTimeout: Duration(milliseconds: config.environment.connectTimeout),
//       receiveTimeout: Duration(milliseconds: config.environment.receiveTimeout),
//       headers: config.environment.headers,
//     );
//
//     return dio;
//   });
//
//   sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
// }

Future<void> _initExternal(AppConfig config) async {
  // Database with flavor-specific name
  // final database = await $FloorAppDatabase
  //     .databaseBuilder(config.databaseName)
  //     .build();
  // sl.registerSingleton<AppDatabase>(database);

  // // Analytics (only in staging/production)
  // if (config.environment.enableAnalytics) {
  //   // Initialize analytics
  // }
}

Future<void> _initAuth() async {}
