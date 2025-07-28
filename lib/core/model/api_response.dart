import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final T? data;
  final String message;
  final List<String> errors;

  const ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.errors,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] ?? '',
      errors: List<String>.from(json['errors'] ?? []),
    );
  }

  @override
  List<Object?> get props => [success, data, message, errors];
}
