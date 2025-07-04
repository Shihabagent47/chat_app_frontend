import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';

class SaveThemeUseCase implements UseCase<void, ThemeEntity> {
  final ThemeRepository repository;

  SaveThemeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ThemeEntity params) async {
    try {
      await repository.saveTheme(params);
      return const Right(null); // Right<void> — since no value to return
    } catch (e) {
      return Left(
        CacheFailure('Failed to save theme'),
      ); // Or better: map specific exceptions
    }
  }
}
