import 'package:flutter/material.dart';

class CalculatorTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Icon> icons;
  final List<String> texts;

  const CalculatorTabBar({super.key, required this.icons, required this.texts});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: List.generate(
        icons.length,
        (index) => Tab(icon: icons[index], text: texts[index]),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
