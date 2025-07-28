import 'package:equatable/equatable.dart';
import 'pagination_meta.dart';

class PaginatedListResponse<T> extends Equatable {
  final bool success;
  final List<T> data;
  final String message;
  final List<String> errors;
  final PaginationMeta meta;

  const PaginatedListResponse({
    required this.success,
    required this.data,
    required this.message,
    required this.errors,
    required this.meta,
  });

  factory PaginatedListResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PaginatedListResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList()
          : <T>[],
      message: json['message'] ?? '',
      errors: List<String>.from(json['errors'] ?? []),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }

  @override
  List<Object> get props => [success, data, message, errors, meta];
}