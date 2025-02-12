import 'package:flutter/material.dart';
import 'package:iouring_code_test/core/utils/color/app_colors.dart';
import 'package:iouring_code_test/core/utils/constants/asset_path.dart';
import 'package:iouring_code_test/core/utils/constants/strings.dart';
import 'package:iouring_code_test/features/watchlist/presentation/pages/watchlist_page.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const WatchListPage(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.bottomNavBarBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.greenColor,
        selectedLabelStyle: const TextStyle(
          color: AppColors.greenColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: const TextStyle(
          color: AppColors.bottomNavBarUnSelectedItemColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        unselectedItemColor: AppColors.bottomNavBarUnSelectedItemColor,
        items: const [
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: ImageIcon(
                  AssetImage(bottomBarWishListIcon),
                ),
              ),
              label: watchList),
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: ImageIcon(
                  AssetImage(bottomBarOrdersIcon),
                ),
              ),
              label: orders),
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: ImageIcon(
                  AssetImage(bottomBarPortfolioIcon),
                ),
              ),
              label: portfolio),
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: ImageIcon(
                  AssetImage(bottomBarMoversIcon),
                ),
              ),
              label: movers),
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: ImageIcon(
                  AssetImage(bottomBarMoreIcon),
                ),
              ),
              label: more),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions?.elementAt(_selectedIndex),
    );
  }
}
