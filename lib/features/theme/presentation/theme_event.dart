part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadThemeEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeType themeType;

  const ChangeThemeEvent({required this.themeType});

  @override
  List<Object> get props => [themeType];
}

class ToggleDarkModeEvent extends ThemeEvent {
  final bool isDark;

  const ToggleDarkModeEvent({required this.isDark});

  @override
  List<Object> get props => [isDark];
}

class ResetThemeEvent extends ThemeEvent {}
