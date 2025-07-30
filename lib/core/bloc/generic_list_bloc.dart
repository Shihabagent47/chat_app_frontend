import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/paginated_list_response.dart';
import '../model/pagination_meta.dart';
import '../model/query_params.dart';

// Generic Events
abstract class GenericListEvent extends Equatable {
  const GenericListEvent();

  @override
  List<Object?> get props => [];
}

class LoadList extends GenericListEvent {
  final QueryParams? queryParams;
  final bool refresh;

  const LoadList({this.queryParams, this.refresh = false});

  @override
  List<Object?> get props => [queryParams, refresh];
}

class LoadMore extends GenericListEvent {}

class RefreshList extends GenericListEvent {}

// Generic States
abstract class GenericListState<T> extends Equatable {
  const GenericListState();

  @override
  List<Object?> get props => [];
}

class ListInitial<T> extends GenericListState<T> {}

class ListLoading<T> extends GenericListState<T> {
  final List<T> currentItems;
  final bool isLoadingMore;

  const ListLoading({this.currentItems = const [], this.isLoadingMore = false});

  @override
  List<Object?> get props => [currentItems, isLoadingMore];
}

class ListLoaded<T> extends GenericListState<T> {
  final List<T> items;
  final PaginationMeta meta;
  final bool hasReachedMax;
  final QueryParams? currentQueryParams;

  const ListLoaded({
    required this.items,
    required this.meta,
    required this.hasReachedMax,
    this.currentQueryParams,
  });

  @override
  List<Object?> get props => [items, meta, hasReachedMax, currentQueryParams];
}

class ListError<T> extends GenericListState<T> {
  final String message;
  final List<String> errors;
  final List<T> currentItems;

  const ListError({
    required this.message,
    this.errors = const [],
    this.currentItems = const [],
  });

  @override
  List<Object?> get props => [message, errors, currentItems];
}

// Generic BLoC
// Update your GenericListBloc - change the method from private to protected
abstract class GenericListBloc<T>
    extends Bloc<GenericListEvent, GenericListState<T>> {
  GenericListBloc() : super(ListInitial<T>()) {
    on<LoadList>(onLoadList); // Change this line
    on<LoadMore>(_onLoadMore);
    on<RefreshList>(_onRefreshList);
  }

  // Abstract method to be implemented by specific BLoCs
  Future<PaginatedListResponse<T>> fetchData(QueryParams queryParams);

  // Method to create default query params - must be implemented by specific BLoCs
  QueryParams getDefaultQueryParams();

  // Method to create next page query params - must be implemented by specific BLoCs
  QueryParams getNextPageQueryParams(QueryParams currentParams, int nextPage);

  @protected
  Future<void> onLoadList(
    LoadList event,
    Emitter<GenericListState<T>> emit,
  ) async {
    final queryParams = event.queryParams ?? getDefaultQueryParams();
    final isFirstPage = queryParams.page == 1;
    final isRefresh = event.refresh;

    // Determine current items to preserve during loading
    List<T> currentItems = <T>[];
    if (!isRefresh && !isFirstPage && state is ListLoaded<T>) {
      currentItems = (state as ListLoaded<T>).items;
    }

    // Emit loading state
    if (isRefresh || state is ListInitial<T> || isFirstPage) {
      emit(const ListLoading());
    } else {
      emit(ListLoading(currentItems: currentItems, isLoadingMore: true));
    }

    try {
      final response = await fetchData(queryParams);

      if (response.success) {
        List<T> newItems;

        // For refresh or first page, start fresh
        if (isRefresh || isFirstPage) {
          newItems = response.data;
        } else {
          // For subsequent pages, append to existing items
          newItems = [...currentItems, ...response.data];
        }

        final hasReachedMax =
            !response.meta.hasNextPage || response.data.isEmpty;

        emit(
          ListLoaded<T>(
            items: newItems,
            meta: response.meta,
            hasReachedMax: hasReachedMax,
            currentQueryParams: queryParams,
          ),
        );
      } else {
        emit(
          ListError<T>(
            message: response.message,
            errors: response.errors,
            currentItems: currentItems,
          ),
        );
      }
    } catch (e) {
      emit(ListError<T>(message: e.toString(), currentItems: currentItems));
    }
  }

  Future<void> _onLoadMore(
    LoadMore event,
    Emitter<GenericListState<T>> emit,
  ) async {
    if (state is ListLoaded<T>) {
      final currentState = state as ListLoaded<T>;
      if (!currentState.hasReachedMax &&
          currentState.currentQueryParams != null) {
        final nextPage = currentState.meta.nextPage;
        final nextPageParams = getNextPageQueryParams(
          currentState.currentQueryParams!,
          nextPage,
        );
        add(LoadList(queryParams: nextPageParams));
      }
    }
  }

  Future<void> _onRefreshList(
    RefreshList event,
    Emitter<GenericListState<T>> emit,
  ) async {
    final currentParams =
        state is ListLoaded<T>
            ? (state as ListLoaded<T>).currentQueryParams
            : null;

    QueryParams refreshParams;
    if (currentParams != null) {
      // Create a copy of current params but reset to page 1
      refreshParams = getNextPageQueryParams(currentParams, 1);
    } else {
      refreshParams = getDefaultQueryParams();
    }

    add(LoadList(queryParams: refreshParams, refresh: true));
  }
}
