import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';

abstract class WatchListState {}

class WatchListLoading extends WatchListState {}

class WatchListLoaded extends WatchListState {
  final List<SymbolEntity> watchList;
  final int selectedGroupIndex;
  final bool isEditing;
  final String searchQuery;

  WatchListLoaded({
    required this.watchList,
    required this.selectedGroupIndex,
    this.isEditing = false,
    this.searchQuery = "",
  });

  WatchListLoaded copyWith({
    List<SymbolEntity>? watchList,
    int? selectedGroupIndex,
    bool? isEditing,
    String? searchQuery,
  }) {
    return WatchListLoaded(
      watchList: watchList ?? this.watchList,
      selectedGroupIndex: selectedGroupIndex ?? this.selectedGroupIndex,
      isEditing: isEditing ?? this.isEditing,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class WatchListError extends WatchListState {
  final String message;

  WatchListError(this.message);
}
