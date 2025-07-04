import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases. [Type] is the return type, [Params] is the parameter type.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// NoParams can be used for use cases that do not require any parameters.
class NoParams {}
