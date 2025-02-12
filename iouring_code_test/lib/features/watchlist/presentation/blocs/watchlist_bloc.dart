import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';
import 'package:iouring_code_test/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_event.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_state.dart';

class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  final GetWatchListUseCase getWatchListUseCase;

  WatchListBloc(this.getWatchListUseCase) : super(WatchListLoading()) {
    on<LoadWatchList>(_onLoadWatchList);
    on<ChangeWatchListGroup>(_onChangeWatchlistGroup);
    on<ReorderWatchList>((event, emit) {
      if (state is WatchListLoaded) {
        final watchlist =
            List<SymbolEntity>.from((state as WatchListLoaded).watchList);
        final movedItem = watchlist.removeAt(event.oldIndex);
        watchlist.insert(event.newIndex, movedItem);
        emit(WatchListLoaded(watchlist));
      }
    });
  }

  Future<void> _onLoadWatchList(
      LoadWatchList event, Emitter<WatchListState> emit) async {
    final watchlist = await getWatchListUseCase.call();
    emit(WatchListLoaded(watchlist));
  }

  Future<void> _onChangeWatchlistGroup(
      ChangeWatchListGroup event, Emitter<WatchListState> emit) async {
    final watchlist = await getWatchListUseCase.call();
    emit(WatchListLoaded(watchlist));
  }
}
