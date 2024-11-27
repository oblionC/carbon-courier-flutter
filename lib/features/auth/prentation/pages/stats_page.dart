import 'package:flutter/material.dart';
import 'package:go_green/core/theme/app_palette.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stats"),
        backgroundColor: AppPallete.backgroundColor,
      ),
    );
  }
}