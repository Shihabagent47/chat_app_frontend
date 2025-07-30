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

  Future<PaginatedListResponse<T>> getPaginatedList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    QueryParams? queryParams,
  }) async {
    final params =
        queryParams?.toQueryMap() ?? const BasePaginationParams().toMap();
    final response = await dioClient.client.get(
      endpoint,
      queryParameters: params,
    );

    if (response.statusCode == 200) {
      return PaginatedListResponse<T>.fromJson(response.data, fromJson);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<ApiResponse<T>> getSingle<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await dioClient.client.get(
      endpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      return ApiResponse<T>.fromJson(
        response.data,
        (data) => fromJson(data as Map<String, dynamic>),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    final response = await dioClient.client.post(endpoint, data: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse<T>.fromJson(
        response.data,
        fromJson != null
            ? (data) => fromJson(data as Map<String, dynamic>)
            : null,
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    final response = await dioClient.client.put(endpoint, data: data);

    if (response.statusCode == 200) {
      return ApiResponse<T>.fromJson(
        response.data,
        fromJson != null
            ? (data) => fromJson(data as Map<String, dynamic>)
            : null,
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<ApiResponse<dynamic>> delete(String endpoint) async {
    final response = await dioClient.client.delete(endpoint);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return ApiResponse<dynamic>.fromJson(
        response.data ??
            {'success': true, 'message': 'Deleted successfully', 'errors': []},
        null,
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
