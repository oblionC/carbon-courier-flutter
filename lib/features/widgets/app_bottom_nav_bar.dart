import 'package:flutter/material.dart';
import 'package:go_green/core/theme/app_palette.dart';

class AppBottomNavBar extends StatelessWidget {
  final Function handleTap;
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.handleTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        handleTap(index);
      },
      currentIndex: currentIndex,
      backgroundColor: AppPallete.backgroundColor,
      selectedItemColor: AppPallete.gradient1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: "Stats"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp),
          label: "Profile"
        )
    ]);
  }
}