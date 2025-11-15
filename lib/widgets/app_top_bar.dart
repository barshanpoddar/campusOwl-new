import 'package:flutter/material.dart';
import 'app_icon.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onToggleTheme;

  const AppTopBar({Key? key, this.title = 'CampusOwl', this.onToggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: onToggleTheme,
          icon: const AppIcon(assetName: 'sun', icon: Icons.brightness_6),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
