import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/routing/navigation_helper.dart';
import '../../../../shared/widgets/common/generic_paginated_list.dart';
import '../../domain/entities/chat_room.dart';
import '../bloc/chat_list_bloc.dart';
import '../widget/chat_list_item.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: BlocProvider(
        create: (context) => context.read<ChatListBloc>(),
        child: GenericPaginatedList(
          bloc: context.read<ChatListBloc>(),
          itemBuilder:
              (context, chatRoom, index) =>
                  ChatRoomListItem(chatRoom: chatRoom, onTap: () {}),
        ),
      ),
    );
  }
}
