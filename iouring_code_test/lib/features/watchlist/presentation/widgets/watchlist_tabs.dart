import 'package:flutter/material.dart';
import 'package:iouring_code_test/core/utils/color/app_colors.dart';
import 'package:iouring_code_test/core/utils/constants/strings.dart';

class WatchListTabs extends StatefulWidget {
  final Function(int) onTabChanged;

  const WatchListTabs({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  _WatchListTabsState createState() => _WatchListTabsState();
}

class _WatchListTabsState extends State<WatchListTabs> {
  int selectedIndex = 0;

  final List<String> tabs = [nifty, bankNifty, senSex];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.asMap().entries.map((entry) {
          int idx = entry.key;
          String name = entry.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = idx;
                });
                widget.onTabChanged(idx);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selectedIndex == idx
                          ? AppColors.greenColor
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedIndex == idx
                        ? AppColors.greenColor
                        : AppColors.textColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
