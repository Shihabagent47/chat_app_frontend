import 'package:chat_app_user/core/model/paginated_list_response.dart';
import 'package:chat_app_user/core/model/pagination_meta.dart';
import 'package:chat_app_user/core/model/query_params.dart';

import '../../../../core/bloc/generic_list_bloc.dart';
import '../../data/models/chat_query_params.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/usecases/get_chat_room.dart';

class ChatListBloc extends GenericListBloc<ChatRoom> {
  final GetChatRoomsUseCase getChatRoomsUseCase;

  ChatListBloc({required this.getChatRoomsUseCase});

  @override
  Future<PaginatedListResponse<ChatRoom>> fetchData(
    QueryParams queryParams,
  ) async {
    final chatQueryParams = queryParams as ChatQueryParams;
    final result = await getChatRoomsUseCase(chatQueryParams);

    return result.fold(
      (failure) => PaginatedListResponse<ChatRoom>(
        success: false,
        data: [],
        message: failure.message,
        errors: [failure.message],
        meta: const PaginationMeta(page: 1, limit: 10, total: 0, pages: 0),
      ),
      (response) => response,
    );
  }

  @override
  QueryParams getNextPageQueryParams(QueryParams currentParams, int nextPage) {
    final chatParams = currentParams as ChatQueryParams;
    return chatParams.copyWith(page: nextPage);
  }

  @override
  QueryParams getDefaultQueryParams() {
    return const ChatQueryParams(page: 1, limit: 10);
  }
}
