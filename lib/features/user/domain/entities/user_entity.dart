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
