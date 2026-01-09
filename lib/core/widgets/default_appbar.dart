import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.calculate),
      title: const Text('Ethiopian Income Calculator'),
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
