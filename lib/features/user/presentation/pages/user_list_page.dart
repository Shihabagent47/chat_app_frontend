import 'package:chat_app_user/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/routing/navigation_helper.dart';
import '../../../../shared/widgets/common/generic_paginated_list.dart';
import '../bloc/user_list_bloc.dart';
import '../widget/user_Llist_item.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocProvider(
        create: (context) => context.read<UserListBloc>(),
        child: GenericPaginatedList(
          bloc: context.read<UserListBloc>(),
          itemBuilder:
              (context, user, index) => UserListItem(user: user, onTap: () {}),
        ),
      ),
    );
  }
}
