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
  State<GenericPaginatedList<T>> createState() => _GenericPaginatedListState<T>();
}

class _GenericPaginatedListState<T> extends State<GenericPaginatedList<T>> {
  final ScrollController _scrollController = ScrollController();

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
    if (_isBottom) {
      widget.bloc.add(LoadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericListBloc<T>, GenericListState<T>>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is ListInitial<T> ||
            (state is ListLoading<T> && state.currentItems.isEmpty)) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

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
                  ...state.errors.map((error) => Text(
                    error,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => widget.bloc.add(const LoadList(refresh: true)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<T> items = [];
        bool isLoadingMore = false;
        bool hasReachedMax = false;

        if (state is ListLoaded<T>) {
          items = state.items;
          hasReachedMax = state.hasReachedMax;
        } else if (state is ListLoading<T>) {
          items = state.currentItems;
          isLoadingMore = state.isLoadingMore;
        } else if (state is ListError<T>) {
          items = state.currentItems;
        }

        if (items.isEmpty) {
          return widget.emptyWidget ??
              const Center(child: Text('No items found'));
        }

        Widget listView = ListView.builder(
          controller: _scrollController,
          padding: widget.padding,
          itemCount: items.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return widget.itemBuilder(context, items[index], index);
          },
        );

        if (widget.enableRefresh) {
          return RefreshIndicator(
            onRefresh: () async {
              widget.bloc.add(RefreshList());
              // Wait for the refresh to complete
              await widget.bloc.stream
                  .firstWhere((state) => state is! ListLoading<T>);
            },
            child: listView,
          );
        }

        return listView;
      },
    );
  }
}
