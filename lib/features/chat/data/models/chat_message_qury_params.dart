import '../../../../core/model/query_params.dart';

class ChatMessageQueryParams extends QueryParams {
  final String? status;
  final String? type;
  final String? sort;
  final String? order;

  const ChatMessageQueryParams({
    super.page,
    super.limit,
    super.q,
    this.status,
    this.type,
    this.sort,
    this.order,
  });

  @override
  Map<String, dynamic> toQueryMap() {
    final baseMap = super.toMap();

    // Add specific chat filters
    if (status != null && status!.isNotEmpty) baseMap['status'] = status;
    if (type != null && type!.isNotEmpty) baseMap['type'] = type;
    if (sort != null && sort!.isNotEmpty) baseMap['sort'] = sort;
    if (order != null && order!.isNotEmpty) baseMap['order'] = order;

    return baseMap;
  }

  ChatMessageQueryParams copyWith({
    int? page,
    int? limit,
    String? q,
    String? status,
    String? type,
    String? sort,
    String? order,
  }) {
    return ChatMessageQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      q: q ?? this.q,
      status: status ?? this.status,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [...super.props, status, type, sort, order];
}
