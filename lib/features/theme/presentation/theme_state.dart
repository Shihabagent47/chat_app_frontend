part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeEntity themeEntity;
  final bool isLoading;
  final String? error;

  const ThemeState({
    this.themeEntity = const ThemeEntity(
      themeType: ThemeType.system,
      isDarkMode: false,
    ),
    this.isLoading = false,
    this.error,
  });

  ThemeState copyWith({
    ThemeEntity? themeEntity,
    bool? isLoading,
    String? error,
  }) {
    return ThemeState(
      themeEntity: themeEntity ?? this.themeEntity,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [themeEntity, isLoading, error];
}
