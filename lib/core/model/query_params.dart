import 'package:equatable/equatable.dart';

// Base query parameters that are common across all paginated requests
class BasePaginationParams extends Equatable {
  final int page;
  final int limit;
  final String? q; // Global search query

  const BasePaginationParams({
    this.page = 1,
    this.limit = 10,
    this.q,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (q != null && q!.isNotEmpty) {
      map['q'] = q;
    }

    return map;
  }

  BasePaginationParams copyWith({
    int? page,
    int? limit,
    String? q,
  }) {
    return BasePaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      q: q ?? this.q,
    );
  }

  @override
  List<Object?> get props => [page, limit, q];
}


// Generic query parameters that extend base params
abstract class QueryParams extends BasePaginationParams {
  const QueryParams({
    super.page,
    super.limit,
    super.q,
  });

  // Method to convert specific params to map
  Map<String, dynamic> toQueryMap();
}
