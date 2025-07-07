import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/responsive_navigation.dart';

class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return ResponsiveNavigation(
            items: state.navigationItems,
            selectedIndex: state.selectedIndex,
            onItemSelected: (index) {
              context.read<HomeBloc>().add(NavigationItemSelected(index));
            },
            child: child,
          );
        }

        return Scaffold(body: Center(child: child));
      },
    );
  }
}
