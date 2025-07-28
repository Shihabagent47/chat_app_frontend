import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../model/api_response.dart';
import '../model/paginated_list_response.dart';
import '../model/query_params.dart';
import '../network/dio_client.dart';

abstract class BaseRepository {
  final DioClient dioClient;

  BaseRepository({required this.dioClient});

  // Generic method for paginated list requests
  Future<Either<Failure, PaginatedListResponse<T>>> getPaginatedList<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson, {
        QueryParams? queryParams,
      }) async {
    try {
      final params = queryParams?.toQueryMap() ?? const BasePaginationParams().toMap();

      final response = await dioClient.client.get(
        endpoint,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final paginatedResponse = PaginatedListResponse<T>.fromJson(
          response.data,
          fromJson,
        );
        return Right(paginatedResponse);
      } else {
        return Left(ServerFailure('Failed to load data: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  // Generic method for single item requests
  Future<Either<Failure, ApiResponse<T>>> getSingle<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      final response = await dioClient.client.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<T>.fromJson(
          response.data,
              (data) => fromJson(data as Map<String, dynamic>),
        );
        return Right(apiResponse);
      } else {
        return Left(ServerFailure('Failed to load data: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Generic POST method
  Future<Either<Failure, ApiResponse<T>>> post<T>(
      String endpoint,
      Map<String, dynamic> data,
      T Function(Map<String, dynamic>)? fromJson,
      ) async {
    try {
      final response = await dioClient.client.post(
        endpoint,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse<T>.fromJson(
          response.data,
          fromJson != null ? (data) => fromJson(data as Map<String, dynamic>) : null,
        );
        return Right(apiResponse);
      } else {
        return Left(ServerFailure('Failed to create data: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Generic PUT method
  Future<Either<Failure, ApiResponse<T>>> put<T>(
      String endpoint,
      Map<String, dynamic> data,
      T Function(Map<String, dynamic>)? fromJson,
      ) async {
    try {
      final response = await dioClient.client.put(
        endpoint,
        data: data,
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<T>.fromJson(
          response.data,
          fromJson != null ? (data) => fromJson(data as Map<String, dynamic>) : null,
        );
        return Right(apiResponse);
      } else {
        return Left(ServerFailure('Failed to update data: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Generic DELETE method
  Future<Either<Failure, ApiResponse<dynamic>>> delete(String endpoint) async {
    try {
      final response = await dioClient.client.delete(endpoint);

      if (response.statusCode == 200 || response.statusCode == 204) {
        final apiResponse = ApiResponse<dynamic>.fromJson(
          response.data ?? {'success': true, 'message': 'Deleted successfully', 'errors': []},
          null,
        );
        return Right(apiResponse);
      } else {
        return Left(ServerFailure('Failed to delete data: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Handle Dio errors consistently
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode != null) {
          // Try to extract error message from your API response format
          if (data is Map<String, dynamic>) {
            final message = data['message'] ?? 'Server error occurred';
            final errors = List<String>.from(data['errors'] ?? []);
            return ServerFailure('$message${errors.isNotEmpty ? ' - ${errors.join(', ')}' : ''}');
          }
          return ServerFailure('Server error: $statusCode');
        }
        return const ServerFailure('Bad response from server');

      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('Certificate error');

      case DioExceptionType.unknown:
      default:
        return ServerFailure('Network error: ${error.message}');
    }
  }
}