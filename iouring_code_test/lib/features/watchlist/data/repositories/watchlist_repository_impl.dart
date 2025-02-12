import 'package:iouring_code_test/features/watchlist/data/data_sources/mock_watchlist_data_source.dart';
import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';
import 'package:iouring_code_test/features/watchlist/domain/repositories/watchlist_repository.dart';

class WatchListRepositoryImpl implements WatchListRepository {
  @override
  List<SymbolEntity> getWatchList() {
    return MockWatchlistDataSource.watchlist;
  }
}
