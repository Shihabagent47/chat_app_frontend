import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';
import '../models/theme_model.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<ThemeEntity> getTheme() async {
    return await localDataSource.getTheme();
  }

  @override
  Future<void> saveTheme(ThemeEntity theme) async {
    final themeModel = ThemeModel.fromEntity(theme);
    await localDataSource.saveTheme(themeModel);
  }

  @override
  Future<void> clearTheme() async {
    await localDataSource.clearTheme();
  }
}
