import 'package:flutter/material.dart';
import 'package:go_green/features/auth/prentation/pages/home_page.dart';
import 'package:go_green/features/auth/prentation/pages/stats_page.dart';
import 'package:go_green/features/auth/prentation/pages/profile_page.dart';
import 'package:go_green/features/widgets/app_bottom_nav_bar.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});
  static route() => MaterialPageRoute(builder: (context) => const AppPage());

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentIndex = 0;

  static const List<Widget> pages = [
    HomePage(),
    StatsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        handleTap: handleNavbarTap,  
      ),
    );
  }

  void handleNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}