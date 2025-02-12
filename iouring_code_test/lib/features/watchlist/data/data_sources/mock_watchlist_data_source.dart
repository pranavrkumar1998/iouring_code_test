import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';

class MockWatchlistDataSource {
  static List<SymbolEntity> watchlist = [
    SymbolEntity(
        id: 1345,
        name: "GOLD 26JUL 59500 CE",
        exchange: "MCX",
        price: 298.50,
        change: 23.50,
        percentageChange: 8.54,
    ),
    SymbolEntity(
        id: 1985,
        name: "ACCELYA",
        exchange: "NSE",
        price: 1337.70,
        change: 1.05,
        percentageChange: 0.07),
    SymbolEntity(
        id: 1934,
        name: "ACC",
        exchange: "BSE",
        price: 1795.20,
        change: 27.20,
        percentageChange: 1.53),
    SymbolEntity(
        id: 8876,
        name: "ACC",
        exchange: "NSE",
        price: 1792.30,
        change: 25.40,
        percentageChange: 1.43),
  ];
}
