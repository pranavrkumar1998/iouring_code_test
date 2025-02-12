import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iouring_code_test/features/home/presentation/pages/home_main_page.dart';
import 'package:iouring_code_test/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:iouring_code_test/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_bloc.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_event.dart';

void main() {
  final watchListRepository = WatchListRepositoryImpl();
  final getWatchListUseCase = GetWatchListUseCase(watchListRepository);
  runApp(MyApp(getWatchListUseCase));
}

class MyApp extends StatelessWidget {
  final GetWatchListUseCase getWatchListUseCase;

  const MyApp(this.getWatchListUseCase, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => WatchListBloc(getWatchListUseCase)..add(LoadWatchList()),
        child: const HomeMainPage(),
      ),
    );
  }
}
