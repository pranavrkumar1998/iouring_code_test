
import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';

abstract class WatchListRepository {
  List<SymbolEntity> getWatchList();
}