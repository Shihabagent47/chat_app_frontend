import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/paginated_list_response.dart';
import '../model/pagination_meta.dart';

// Generic Events
abstract class GenericListEvent extends Equatable {
  const GenericListEvent();

  @override
  List<Object?> get props => [];
}

class LoadList extends GenericListEvent {
  final int page;
  final bool refresh;
  final Map<String, dynamic>? filters;

  const LoadList({
    this.page = 1,
    this.refresh = false,
    this.filters,
  });

  @override
  List<Object?> get props => [page, refresh, filters];
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

  const ListLoading({
    this.currentItems = const [],
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [currentItems, isLoadingMore];
}

class ListLoaded<T> extends GenericListState<T> {
  final List<T> items;
  final PaginationMeta meta;
  final bool hasReachedMax;

  const ListLoaded({
    required this.items,
    required this.meta,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [items, meta, hasReachedMax];
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
abstract class GenericListBloc<T> extends Bloc<GenericListEvent, GenericListState<T>> {
  GenericListBloc() : super(ListInitial<T>()) {
    on<LoadList>(_onLoadList);
    on<LoadMore>(_onLoadMore);
    on<RefreshList>(_onRefreshList);
  }

  // Abstract method to be implemented by specific BLoCs
  Future<PaginatedListResponse<T>> fetchData({
    int page = 1,
    Map<String, dynamic>? filters,
  });

  Future<void> _onLoadList(LoadList event, Emitter<GenericListState<T>> emit) async {
    if (event.refresh || state is ListInitial) {
      emit(const ListLoading());
    } else if (state is ListLoaded<T>) {
      emit(ListLoading(
        currentItems: (state as ListLoaded<T>).items,
        isLoadingMore: true,
      ));
    }

    try {
      final response = await fetchData(
        page: event.page,
        filters: event.filters,
      );

      if (response.success) {
        final currentItems = event.refresh || event.page == 1
            ? <T>[]
            : (state is ListLoaded<T>)
            ? (state as ListLoaded<T>).items
            : <T>[];

        final newItems = [...currentItems, ...response.data];
        final hasReachedMax = !response.meta.hasNextPage;

        emit(ListLoaded<T>(
          items: newItems,
          meta: response.meta,
          hasReachedMax: hasReachedMax,
        ));
      } else {
        emit(ListError<T>(
          message: response.message,
          errors: response.errors,
          currentItems: state is ListLoaded<T>
              ? (state as ListLoaded<T>).items
              : [],
        ));
      }
    } catch (e) {
      emit(ListError<T>(
        message: e.toString(),
        currentItems: state is ListLoaded<T>
            ? (state as ListLoaded<T>).items
            : [],
      ));
    }
  }

  Future<void> _onLoadMore(LoadMore event, Emitter<GenericListState<T>> emit) async {
    if (state is ListLoaded<T>) {
      final currentState = state as ListLoaded<T>;
      if (!currentState.hasReachedMax) {
        add(LoadList(page: currentState.meta.nextPage));
      }
    }
  }

  Future<void> _onRefreshList(RefreshList event, Emitter<GenericListState<T>> emit) async {
    add(const LoadList(page: 1, refresh: true));
  }
}
