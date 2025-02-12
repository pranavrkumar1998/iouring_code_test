import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';
import 'package:iouring_code_test/features/watchlist/domain/repositories/watchlist_repository.dart';

class GetWatchListUseCase {
  final WatchListRepository repository;

  GetWatchListUseCase(this.repository);

  Future<List<SymbolEntity>> call() async {
    return repository.getWatchList();
  }
}