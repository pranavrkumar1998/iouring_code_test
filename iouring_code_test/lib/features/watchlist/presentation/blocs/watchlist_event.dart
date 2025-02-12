import 'package:equatable/equatable.dart';

abstract class WatchListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWatchList extends WatchListEvent {}

class ChangeWatchListGroup extends WatchListEvent {
  final int index;

  ChangeWatchListGroup(this.index);

  @override
  List<Object?> get props => [index];
}

class ReorderWatchList extends WatchListEvent {
  final int oldIndex;
  final int newIndex;

  ReorderWatchList(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class ToggleEditMode extends WatchListEvent {
  final bool isEditing;

  ToggleEditMode(this.isEditing);

  @override
  List<Object?> get props => [isEditing];
}

class UpdateSearchQuery extends WatchListEvent {
  final String searchQuery;

  UpdateSearchQuery(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}
