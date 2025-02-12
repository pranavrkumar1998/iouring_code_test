import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';
import 'package:iouring_code_test/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_event.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_state.dart';

class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  final GetWatchListUseCase getWatchListUseCase;
  bool isEditing = false;
  int selectedGroupIndex = 0;

  WatchListBloc(this.getWatchListUseCase) : super(WatchListLoading()) {
    on<LoadWatchList>(_onLoadWatchList);
    on<ChangeWatchListGroup>(_onChangeWatchlistGroup);
    on<ToggleEditMode>(_onToggleEditMode);
    on<ReorderWatchList>(_onReorderWatchList);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
  }

  Future<void> _onLoadWatchList(
      LoadWatchList event, Emitter<WatchListState> emit) async {
    final watchlist = await getWatchListUseCase.call();
    emit(WatchListLoaded(
        watchList: watchlist,
        selectedGroupIndex: selectedGroupIndex,
        isEditing: isEditing));
  }

  Future<void> _onChangeWatchlistGroup(
      ChangeWatchListGroup event, Emitter<WatchListState> emit) async {
    selectedGroupIndex = event.index;
    final watchlist = await getWatchListUseCase.call();
    emit(WatchListLoaded(
        watchList: watchlist,
        selectedGroupIndex: selectedGroupIndex,
        isEditing: isEditing));
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<WatchListState> emit) {
    isEditing = event.isEditing;
    if (state is WatchListLoaded) {
      emit(WatchListLoaded(
          watchList: (state as WatchListLoaded).watchList,
          selectedGroupIndex: selectedGroupIndex,
          isEditing: isEditing));
    }
  }

  void _onReorderWatchList(
      ReorderWatchList event, Emitter<WatchListState> emit) {
    if (isEditing && state is WatchListLoaded) {
      final watchlist =
          List<SymbolEntity>.from((state as WatchListLoaded).watchList);
      final movedItem = watchlist.removeAt(event.oldIndex);
      watchlist.insert(event.newIndex, movedItem);
      emit(WatchListLoaded(
          watchList: watchlist,
          selectedGroupIndex: selectedGroupIndex,
          isEditing: isEditing));
    }
  }

  void _onUpdateSearchQuery(
      UpdateSearchQuery event, Emitter<WatchListState> emit) {
    if (state is WatchListLoaded) {
      final currentState = state as WatchListLoaded;
      emit(currentState.copyWith(searchQuery: event.searchQuery));
    }
  }
}
