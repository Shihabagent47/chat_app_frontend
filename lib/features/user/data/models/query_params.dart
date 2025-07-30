import '../../../../core/model/query_params.dart';

class UserQueryParams extends QueryParams {
  final String? name;
  final String? email;
  final String? status;
  final String? role;
  final String? sort;
  final String? order;

  const UserQueryParams({
    super.page,
    super.limit,
    super.q,
    this.name,
    this.email,
    this.status,
    this.role,
    this.sort,
    this.order,
  });

  @override
  Map<String, dynamic> toQueryMap() {
    final baseMap = super.toMap();

    // Add specific user filters
    if (name != null && name!.isNotEmpty) baseMap['name'] = name;
    if (email != null && email!.isNotEmpty) baseMap['email'] = email;
    if (status != null && status!.isNotEmpty) baseMap['status'] = status;
    if (role != null && role!.isNotEmpty) baseMap['role'] = role;
    if (sort != null && sort!.isNotEmpty) baseMap['sort'] = sort;
    if (order != null && order!.isNotEmpty) baseMap['order'] = order;

    return baseMap;
  }

  UserQueryParams copyWith({
    int? page,
    int? limit,
    String? q,
    String? name,
    String? email,
    String? status,
    String? role,
    String? sort,
    String? order,
  }) {
    return UserQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      q: q ?? this.q,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      role: role ?? this.role,
      sort: sort ?? this.sort,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    email,
    status,
    role,
    sort,
    order,
  ];
}
