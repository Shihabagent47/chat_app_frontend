enum ThemeType { light, dark, system }

class ThemeEntity {
  final ThemeType themeType;
  final bool isDarkMode;
  final String primaryColor;
  final String accentColor;

  const ThemeEntity({
    required this.themeType,
    required this.isDarkMode,
    this.primaryColor = '#2196F3',
    this.accentColor = '#03DAC6',
  });

  ThemeEntity copyWith({
    ThemeType? themeType,
    bool? isDarkMode,
    String? primaryColor,
    String? accentColor,
  }) {
    return ThemeEntity(
      themeType: themeType ?? this.themeType,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
