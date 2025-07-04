import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/usecases/usecase.dart';
import '../domain/entities/theme_entity.dart';
import '../domain/usecases/get_theme_usecase.dart';
import '../domain/usecases/save_theme_usecase.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;

  ThemeBloc({required this.getThemeUseCase, required this.saveThemeUseCase})
    : super(const ThemeState()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<ResetThemeEvent>(_onResetTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getThemeUseCase(NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (theme) {
        emit(state.copyWith(themeEntity: theme, isLoading: false));
      },
    );
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final newTheme = state.themeEntity.copyWith(
        themeType: event.themeType,
        isDarkMode:
            event.themeType == ThemeType.dark ||
            (event.themeType == ThemeType.system &&
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.dark),
      );

      await saveThemeUseCase(newTheme);

      emit(state.copyWith(themeEntity: newTheme, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final newTheme = state.themeEntity.copyWith(
        themeType: event.isDark ? ThemeType.dark : ThemeType.light,
        isDarkMode: event.isDark,
      );

      await saveThemeUseCase(newTheme);

      emit(state.copyWith(themeEntity: newTheme, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onResetTheme(
    ResetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      const defaultTheme = ThemeEntity(
        themeType: ThemeType.system,
        isDarkMode: false,
      );

      await saveThemeUseCase(defaultTheme);

      emit(state.copyWith(themeEntity: defaultTheme, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
