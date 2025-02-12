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
  int _selectedTabIndex = 0;
  final List<String> watchlistGroups = [nifty, bankNifty, senSex];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text(watchList, style: TextStyle(
        color: AppColors.textColor,
        fontWeight: FontWeight.w500,
        fontSize: 22.0
      ),),
      backgroundColor: AppColors.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Image.asset(pinnedIcon, color: AppColors.textColor, width: 20, height: 20,),
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
                  setState(() {
                    _selectedTabIndex = index;
                    _searchQuery = "";
                    _searchController.clear();
                    _isEditing = false;
                  });
                  context.read<WatchListBloc>().add(ChangeWatchListGroup(index));
                },
              ),
              _buildTextField(),
              _buildSymbolsList(),
            ],
          ),
          _buildEditWatchListWidget(),
        ],
      )
    );
  }

  _buildEditWatchListWidget() => !_isEditing ?
  Positioned(
    bottom: 60,
    child:
    Center(
      child: InkWell(
        onTap: (){
          setState(() {
            _isEditing = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.searchBarColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 14.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Image.asset(editIcon, width: 20, height: 20,
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
  ) : const SizedBox();

  _buildSymbolsList() => Expanded(
    child: BlocBuilder<WatchListBloc, WatchListState>(
      builder: (context, state) {
        if (state is WatchListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WatchListLoaded) {
          List<SymbolEntity> watchlist = state.watchList ?? [];
          List<SymbolEntity> filteredList = _searchQuery.isEmpty
              ? watchlist
              : watchlist.where((symbol) =>
              symbol.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (!_isEditing){
                setState(() {
                  _isEditing = true;
                });
              }
              if (newIndex > oldIndex) newIndex--;
              context.read<WatchListBloc>().add(ReorderWatchList(oldIndex, newIndex));
            },
            children:
            filteredList.map((symbol) {
              return ListTile(
                key: ValueKey(symbol.id),
                contentPadding: const EdgeInsets.only(bottom: 6.0, left: 15.0, right: 15.0),
                title: Text(symbol.name,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(symbol.exchange,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),),
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
                                child: Image.asset(arrowDropUpIcon, color: AppColors.greenColor, width: 12, height: 12,),
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
                          child: Text("+${symbol.change} (${symbol.percentageChange}%)",
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text(somethingWentWrong));
        }
      },
    ),
  );

  _buildTextField() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: TextField(
      enabled: _isEditing,
      controller: _searchController,
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
        });
      },
      decoration: InputDecoration(
        hintText: "$search ${watchlistGroups[_selectedTabIndex]}",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: AppColors.searchBarColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      style: const TextStyle(color: Colors.white),
    ),
  );
}