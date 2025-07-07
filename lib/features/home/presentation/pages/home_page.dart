import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/navigation_repository.dart';
import '../../domain/usecases/get_navigation_items.dart';
import '../../domain/usecases/update_navigation_selection.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_content.dart';
import '../widgets/responsive_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HomeBloc(
            getNavigationItems: GetNavigationItems(NavigationRepositoryImpl()),
            updateNavigationSelection: UpdateNavigationSelection(
              NavigationRepositoryImpl(),
            ),
          )..add(HomeInitialized()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HomeError) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        }

        if (state is HomeLoaded) {
          return ResponsiveNavigation(
            items: state.navigationItems,
            selectedIndex: state.selectedIndex,
            onItemSelected: (index) {
              context.read<HomeBloc>().add(NavigationItemSelected(index));
            },
            child: const HomeContent(),
          );
        }

        return const Scaffold(body: Center(child: Text('Welcome to Home')));
      },
    );
  }
}
