import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_list_bloc.dart';
import '../widget/user_details_content.dart';

class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details'), actions: []),
      // body:
      // BlocListener<UserBloc, UserState>(
      //   listener: (context, state) {
      //     if (state is UserDetailsError) {
      //       ScaffoldMessenger.of(
      //         context,
      //       ).showSnackBar(SnackBar(content: Text(state.message)));
      //     }
      //   },
      //   child: BlocBuilder<UserBloc, UserState>(
      //     builder: (context, state) {
      //       if (state is UserDetailsLoading) {
      //         return const Center(child: CircularProgressIndicator());
      //       } else if (state is UserDetailsLoaded) {
      //         return UserDetailsContent(user: state.user);
      //       } else if (state is UserDetailsError) {
      //         return Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text('Error: ${state.message}'),
      //               const SizedBox(height: 16),
      //               ElevatedButton(
      //                 onPressed: () {
      //                   context.read<UserBloc>().add(LoadUserDetails(userId));
      //                 },
      //                 child: const Text('Retry'),
      //               ),
      //             ],
      //           ),
      //         );
      //       }
      //
      //       // Load user details when page opens
      //       Future.microtask(() {
      //         context.read<UserBloc>().add(LoadUserDetails(userId));
      //       });
      //
      //       return const Center(child: CircularProgressIndicator());
      //     },
      //   ),
      // ),
    );
  }
}
