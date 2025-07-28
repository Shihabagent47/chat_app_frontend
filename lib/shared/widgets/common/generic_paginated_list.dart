import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/generic_list_bloc.dart';

class GenericPaginatedList<T> extends StatefulWidget {
  final GenericListBloc<T> bloc;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool enableRefresh;
  final EdgeInsets? padding;

  const GenericPaginatedList({
    Key? key,
    required this.bloc,
    required this.itemBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.enableRefresh = true,
    this.padding,
  }) : super(key: key);

  @override
  State<GenericPaginatedList<T>> createState() =>
      _GenericPaginatedListState<T>();
}

class _GenericPaginatedListState<T> extends State<GenericPaginatedList<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    widget.bloc.add(const LoadList());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isLoadingMore && !_hasReachedMax) {
      _loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger loading when user is 200 pixels from the bottom
    return currentScroll >= (maxScroll - 200);
  }

  void _loadMore() {
    if (!_isLoadingMore && !_hasReachedMax) {
      setState(() {
        _isLoadingMore = true;
      });
      widget.bloc.add(LoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenericListBloc<T>, GenericListState<T>>(
      bloc: widget.bloc,
      listener: (context, state) {
        // Update local loading state based on bloc state
        if (state is ListLoaded<T>) {
          _isLoadingMore = false;
          _hasReachedMax = state.hasReachedMax;
        } else if (state is ListLoading<T>) {
          _isLoadingMore = state.isLoadingMore;
        } else if (state is ListError<T>) {
          _isLoadingMore = false;
        }
      },
      child: BlocBuilder<GenericListBloc<T>, GenericListState<T>>(
        bloc: widget.bloc,
        builder: (context, state) {
          // Handle initial loading state
          if (state is ListInitial<T> ||
              (state is ListLoading<T> && state.currentItems.isEmpty)) {
            return widget.loadingWidget ??
                const Center(child: CircularProgressIndicator());
          }

          // Handle error state with no items
          if (state is ListError<T> && state.currentItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (state.errors.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...state.errors.map(
                      (error) => Text(
                        error,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _isLoadingMore = false;
                      _hasReachedMax = false;
                      widget.bloc.add(const LoadList(refresh: true));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Extract items from current state
          List<T> items = [];
          bool showBottomLoader = false;

          if (state is ListLoaded<T>) {
            items = state.items;
            _hasReachedMax = state.hasReachedMax;
            showBottomLoader = false;
          } else if (state is ListLoading<T>) {
            items = state.currentItems;
            showBottomLoader = state.isLoadingMore && items.isNotEmpty;
          } else if (state is ListError<T>) {
            items = state.currentItems;
            showBottomLoader = false;
          }

          // Handle empty state
          if (items.isEmpty) {
            return widget.emptyWidget ??
                const Center(child: Text('No items found'));
          }

          // Build the list view
          Widget listView = ListView.builder(
            controller: _scrollController,
            padding: widget.padding,
            itemCount: items.length + (showBottomLoader ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom
              if (index >= items.length) {
                return Container(
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return widget.itemBuilder(context, items[index], index);
            },
          );

          // Add pull-to-refresh if enabled
          if (widget.enableRefresh) {
            return RefreshIndicator(
              onRefresh: () async {
                _isLoadingMore = false;
                _hasReachedMax = false;
                widget.bloc.add(RefreshList());
                // Wait for the refresh to complete
                await widget.bloc.stream.firstWhere(
                  (state) => state is! ListLoading<T>,
                );
              },
              child: listView,
            );
          }

          return listView;
        },
      ),
    );
  }
}
