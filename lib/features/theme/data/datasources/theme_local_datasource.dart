import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/theme_entity.dart';
import '../models/theme_model.dart';

abstract class ThemeLocalDataSource {
  Future<ThemeModel> getTheme();
  Future<void> saveTheme(ThemeModel theme);
  Future<void> clearTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String THEME_KEY = 'THEME_KEY';

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeModel> getTheme() async {
    final jsonString = sharedPreferences.getString(THEME_KEY);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return ThemeModel.fromJson(jsonMap);
    }

    // Default theme
    return const ThemeModel(themeType: ThemeType.system, isDarkMode: false);
  }

  @override
  Future<void> saveTheme(ThemeModel theme) async {
    final jsonString = json.encode(theme.toJson());
    await sharedPreferences.setString(THEME_KEY, jsonString);
  }

  @override
  Future<void> clearTheme() async {
    await sharedPreferences.remove(THEME_KEY);
  }
}
