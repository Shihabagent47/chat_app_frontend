import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';

class GetThemeUseCase implements UseCase<ThemeEntity, NoParams> {
  final ThemeRepository repository;

  GetThemeUseCase(this.repository);

  @override
  Future<Either<Failure, ThemeEntity>> call(NoParams params) async {
    try {
      final theme = await repository.getTheme();
      return Right(theme);
    } catch (e) {
      print('Failed to get theme: $e');
      return Left(CacheFailure('Failed to get theme'));
    }
  }
}
