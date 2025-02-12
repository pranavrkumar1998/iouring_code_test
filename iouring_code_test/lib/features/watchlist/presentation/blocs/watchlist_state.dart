import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';

abstract class WatchListState {}

class WatchListLoading extends WatchListState {}

class WatchListLoaded extends WatchListState {
  final List<SymbolEntity> watchList;

  WatchListLoaded(this.watchList);
}
