import '../entities/theme_entity.dart';

abstract class ThemeRepository {
  Future<ThemeEntity> getTheme();
  Future<void> saveTheme(ThemeEntity theme);
  Future<void> clearTheme();
}
