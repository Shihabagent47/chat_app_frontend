import '../../domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  const ThemeModel({
    required super.themeType,
    required super.isDarkMode,
    super.primaryColor,
    super.accentColor,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      themeType: ThemeType.values.firstWhere(
        (e) => e.toString() == 'ThemeType.${json['themeType']}',
        orElse: () => ThemeType.system,
      ),
      isDarkMode: json['isDarkMode'] ?? false,
      primaryColor: json['primaryColor'] ?? '#2196F3',
      accentColor: json['accentColor'] ?? '#03DAC6',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeType': themeType.toString().split('.').last,
      'isDarkMode': isDarkMode,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
    };
  }

  factory ThemeModel.fromEntity(ThemeEntity entity) {
    return ThemeModel(
      themeType: entity.themeType,
      isDarkMode: entity.isDarkMode,
      primaryColor: entity.primaryColor,
      accentColor: entity.accentColor,
    );
  }
}
