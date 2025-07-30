import 'package:bloc/bloc.dart';
import 'package:chat_app_user/core/model/paginated_list_response.dart';
import 'package:chat_app_user/core/model/pagination_meta.dart';
import 'package:chat_app_user/core/model/query_params.dart';
import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:chat_app_user/features/user/domain/repositories/user_repository.dart';
import 'package:chat_app_user/features/user/domain/usecases/get_users_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/bloc/generic_list_bloc.dart';

import '../../data/models/query_params.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserListBloc extends GenericListBloc<UserEntity> {
  final GetUsersUseCase getUsersUseCase;

  UserListBloc({required this.getUsersUseCase});

  @override
  Future<PaginatedListResponse<UserEntity>> fetchData(
    QueryParams queryParams,
  ) async {
    final userQueryParams = queryParams as UserQueryParams;
    final result = await getUsersUseCase(userQueryParams);

    return result.fold(
      (failure) => PaginatedListResponse<UserEntity>(
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
    final userParams = currentParams as UserQueryParams;
    return userParams.copyWith(page: nextPage);
  }

  @override
  QueryParams getDefaultQueryParams() {
    return const UserQueryParams(page: 1, limit: 10);
  }
}
