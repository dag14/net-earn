import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final String title;
  final IconData icon;
  const DefaultAppBar({
    super.key,
    this.actions,
    this.bottom,
    required this.title,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      bottom: bottom,
      leading: Icon(icon),
      title: Text(title),
    );
  }

  @override
  Size get preferredSize {
    final double tapBarHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + tapBarHeight);
  }
}
