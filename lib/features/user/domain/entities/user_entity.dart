import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? profilePhoto;
  final String? about;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.profilePhoto,
    this.about,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phone,
    email,
    profilePhoto,
    about,
  ];
}

class UserListResponseEntity extends Equatable {
  final bool success;
  final List<UserEntity> data;
  final MetaEntity meta;
  final String message;

  const UserListResponseEntity({
    required this.success,
    required this.data,
    required this.meta,
    required this.message,
  });

  @override
  List<Object?> get props => [success, data, meta, message];
}

class MetaEntity extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int pages;

  const MetaEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  @override
  List<Object?> get props => [page, limit, total, pages];
}
