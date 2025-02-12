abstract class WatchListEvent {}

class LoadWatchList extends WatchListEvent {}

class ChangeWatchListGroup extends WatchListEvent {
  final int groupIndex;

  ChangeWatchListGroup(this.groupIndex);
}

class ReorderWatchList extends WatchListEvent {
  final int oldIndex;

  final int newIndex;

  ReorderWatchList(this.oldIndex, this.newIndex);
}
