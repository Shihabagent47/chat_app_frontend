import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_navigation_items.dart';
import '../../domain/usecases/update_navigation_selection.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetNavigationItems _getNavigationItems;
  final UpdateNavigationSelection _updateNavigationSelection;

  HomeBloc({
    required GetNavigationItems getNavigationItems,
    required UpdateNavigationSelection updateNavigationSelection,
  }) : _getNavigationItems = getNavigationItems,
       _updateNavigationSelection = updateNavigationSelection,
       super(HomeInitial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<NavigationItemSelected>(_onNavigationItemSelected);
  }

  Future<void> _onHomeInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());
      final items = _getNavigationItems();
      final selectedIndex = items.indexWhere((item) => item.isSelected);

      emit(
        HomeLoaded(
          navigationItems: items,
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onNavigationItemSelected(
    NavigationItemSelected event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;

        await _updateNavigationSelection(event.index);
        final updatedItems = _getNavigationItems();

        emit(
          HomeLoaded(navigationItems: updatedItems, selectedIndex: event.index),
        );
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
