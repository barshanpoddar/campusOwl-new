import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';
import 'app_icon.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationItem>? items;

  const BottomNavigation(
      {super.key, required this.currentIndex, required this.onTap, this.items});

  @override
  Widget build(BuildContext context) {
    final navItems = items ?? navigationItems;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          return _BottomNavigationItem(
            icon: item.icon,
            asset: item.asset,
            label: item.name,
            isSelected: currentIndex == index,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  final IconData? icon;
  final String? asset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavigationItem({
    this.icon,
    this.asset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Increase the tappable area without changing icon/text sizes by adding
    // a minimum hit target and using InkWell for feedback.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // Keep the visual icon and text sizes unchanged (24 and 12),
          // but provide extra transparent padding and a minimum size so
          // the touchable area is larger.
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (asset != null)
                SvgPicture.asset(
                  asset!,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor!,
                    BlendMode.srcIn,
                  ),
                )
              else
                AppIcon(
                  icon: icon ?? Icons.circle,
                  size: 24,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
