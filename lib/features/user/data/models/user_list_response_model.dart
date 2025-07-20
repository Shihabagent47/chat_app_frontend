import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.email,
    super.profilePhoto,
    super.about,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      profilePhoto: json['profile_photo'],
      about: json['about'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'profile_photo': profilePhoto,
      'about': about,
    };
  }
}

class UserListResponseModel extends UserListResponseEntity {
  const UserListResponseModel({
    required super.success,
    required List<UserModel> data,
    required super.meta,
    required super.message,
  }) : super(data: data);

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) {
    return UserListResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List).map((e) => UserModel.fromJson(e)).toList(),
      meta: MetaModel.fromJson(json['meta']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': (data as List<UserModel>).map((e) => e.toJson()).toList(),
      'meta': (meta as MetaModel).toJson(),
      'message': message,
    };
  }
}

class MetaModel extends MetaEntity {
  const MetaModel({
    required super.page,
    required super.limit,
    required super.total,
    required super.pages,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      pages: json['pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'total': total, 'pages': pages};
  }
}
