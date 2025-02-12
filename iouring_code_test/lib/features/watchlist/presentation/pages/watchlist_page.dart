import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iouring_code_test/core/utils/color/app_colors.dart';
import 'package:iouring_code_test/core/utils/constants/asset_path.dart';
import 'package:iouring_code_test/core/utils/constants/strings.dart';
import 'package:iouring_code_test/features/watchlist/domain/entities/symbol_entity.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_bloc.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_event.dart';
import 'package:iouring_code_test/features/watchlist/presentation/blocs/watchlist_state.dart';
import 'package:iouring_code_test/features/watchlist/presentation/widgets/watchlist_tabs.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  final List<String> watchlistGroups = [nifty, bankNifty, senSex];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text(
            watchList,
            style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 22.0),
          ),
          backgroundColor: AppColors.backgroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Image.asset(
                pinnedIcon,
                color: AppColors.textColor,
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Column(
              children: [
                WatchListTabs(
                  onTabChanged: (index) {
                    _searchController.clear();
                    context.read<WatchListBloc>().add(UpdateSearchQuery(""));
                    context.read<WatchListBloc>().add(ToggleEditMode(false));
                    context
                        .read<WatchListBloc>()
                        .add(ChangeWatchListGroup(index));
                  },
                ),
                _buildTextField(),
                _buildSymbolsList(),
              ],
            ),
            _buildEditWatchListWidget(),
          ],
        ));
  }

  _buildEditWatchListWidget() {
    return BlocBuilder<WatchListBloc, WatchListState>(
        builder: (context, state) {
      if (state is WatchListLoaded && !state.isEditing) {
        return Positioned(
          bottom: 60,
          child: Center(
            child: InkWell(
              onTap: () {
                context.read<WatchListBloc>().add(ToggleEditMode(true));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.searchBarColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 23.0, vertical: 14.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Image.asset(
                              editIcon,
                              width: 20,
                              height: 20,
                              color: AppColors.greenColor,
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: editWatchList,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  _buildSymbolsList() => Expanded(
        child: BlocBuilder<WatchListBloc, WatchListState>(
          builder: (context, state) {
            if (state is WatchListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchListLoaded) {
              List<SymbolEntity> watchlist = state.watchList ?? [];
              List<SymbolEntity> filteredList = state.searchQuery.isEmpty
                  ? watchlist
                  : watchlist
                      .where((symbol) => symbol.name
                          .toLowerCase()
                          .contains(state.searchQuery.toLowerCase()))
                      .toList();
              return ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  if (!state.isEditing) {
                    context.read<WatchListBloc>().add(ToggleEditMode(true));
                  }
                  if (newIndex > oldIndex) newIndex--;
                  context
                      .read<WatchListBloc>()
                      .add(ReorderWatchList(oldIndex, newIndex));
                },
                children: filteredList.map((symbol) {
                  if (!state.isEditing) {
                    return _buildListTileWithLongPressAction(symbol);
                  } else {
                    return _buildListTile(symbol);
                  }
                }).toList(),
              );
            } else {
              return const Center(child: Text(somethingWentWrong));
            }
          },
        ),
      );

  Widget _buildListTile(SymbolEntity symbol) => ListTile(
        key: ValueKey(symbol.id),
        contentPadding:
            const EdgeInsets.only(bottom: 6.0, left: 15.0, right: 15.0),
        title: Text(
          symbol.name,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            symbol.exchange,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Image.asset(
                          arrowDropUpIcon,
                          color: AppColors.greenColor,
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: symbol.price.toString(),
                      style: const TextStyle(
                        color: AppColors.greenColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "+${symbol.change} (${symbol.percentageChange}%)",
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildListTileWithLongPressAction(SymbolEntity symbol) => InkWell(
        key: ValueKey(symbol.id),
        onLongPress: () {
          context.read<WatchListBloc>().add(ToggleEditMode(true));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(editWatchListEnabled)),
          );
        },
        child: ListTile(
          key: ValueKey(symbol.id),
          contentPadding:
              const EdgeInsets.only(bottom: 6.0, left: 15.0, right: 15.0),
          title: Text(
            symbol.name,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              symbol.exchange,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.asset(
                            arrowDropUpIcon,
                            color: AppColors.greenColor,
                            width: 12,
                            height: 12,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: symbol.price.toString(),
                        style: const TextStyle(
                          color: AppColors.greenColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "+${symbol.change} (${symbol.percentageChange}%)",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _buildTextField() =>
      BlocBuilder<WatchListBloc, WatchListState>(builder: (context, state) {
        int selectedGroupIndex =
            context.watch<WatchListBloc>().state is WatchListLoaded
                ? (context.watch<WatchListBloc>().state as WatchListLoaded)
                    .selectedGroupIndex
                : 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            enabled: state is WatchListLoaded && state.isEditing,
            controller: _searchController,
            onChanged: (query) {
              context.read<WatchListBloc>().add(UpdateSearchQuery(query));
            },
            decoration: InputDecoration(
              hintText: "$search ${watchlistGroups[selectedGroupIndex]}",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: AppColors.searchBarColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        );
      });
}
