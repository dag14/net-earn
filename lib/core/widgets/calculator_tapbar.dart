import 'package:flutter/material.dart';

class CalculatorTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Icon> icons;
  final List<String> texts;

  const CalculatorTabBar({super.key, required this.icons, required this.texts});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(icon: icons[0], text: texts[0]),
        Tab(icon: icons[1], text: texts[1]),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
