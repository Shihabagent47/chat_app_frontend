import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AuthResponseEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponseEntity>> call(
    RegisterParams params,
  ) async {
    return await repository.register(
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, phone, email, password];
}
