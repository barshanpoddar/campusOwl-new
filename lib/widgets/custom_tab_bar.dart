import 'package:flutter/material.dart';

/// Model for individual tab items
class CustomTabItem {
  final String id;
  final String label;
  final IconData? icon;

  const CustomTabItem({
    required this.id,
    required this.label,
    this.icon,
  });
}

/// A custom reusable tab bar with animated underline indicator
class CustomTabBar extends StatelessWidget {
  final List<CustomTabItem> tabs;
  final String activeTabId;
  final ValueChanged<String> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final double indicatorHeight;
  final double indicatorWidth;
  final EdgeInsets? padding;
  final bool showDivider;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.activeTabId,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.indicatorHeight = 3,
    this.indicatorWidth = 80,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.primaryColor;
    final effectiveInactiveColor = inactiveColor ?? Colors.grey;
    final effectiveIndicatorColor = indicatorColor ?? theme.primaryColor;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);

    return Container(
      padding: effectivePadding,
      child: Column(
        children: [
          Row(
            children: tabs.map((tab) {
              final isActive = activeTabId == tab.id;
              return Expanded(
                child: TextButton(
                  onPressed: () => onTabChanged(tab.id),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (tab.icon != null) ...[
                        Icon(
                          tab.icon,
                          size: 20,
                          color: isActive
                              ? effectiveActiveColor
                              : effectiveInactiveColor,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        tab.label,
                        style: TextStyle(
                          color: isActive
                              ? effectiveActiveColor
                              : effectiveInactiveColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          // Divider and animated underline indicator
          SizedBox(
            height: 28,
            child: Stack(
              children: [
                // Subtle divider line (optional)
                if (showDivider)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                // Animated indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: _calculateAlignment(tabs.length),
                  child: Container(
                    width: indicatorWidth,
                    height: indicatorHeight,
                    decoration: BoxDecoration(
                      color: effectiveIndicatorColor,
                      borderRadius: BorderRadius.circular(indicatorHeight / 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate the alignment for the indicator based on active tab
  Alignment _calculateAlignment(int totalTabs) {
    final activeIndex = tabs.indexWhere((tab) => tab.id == activeTabId);
    if (activeIndex == -1) return Alignment.centerLeft;

    // Calculate position: from -1.0 (leftmost) to 1.0 (rightmost)
    // For 2 tabs: index 0 => -0.6, index 1 => 0.6
    // For 3 tabs: index 0 => -0.8, index 1 => 0.0, index 2 => 0.8
    // For 4 tabs: index 0 => -0.9, index 1 => -0.3, index 2 => 0.3, index 3 => 0.9

    if (totalTabs == 1) return Alignment.center;

    // Map index to range
    final step = 2.0 / (totalTabs - 1);
    final position = -1.0 + (activeIndex * step);

    // Apply slight adjustment for better centering (adjust multiplier as needed)
    final adjustedPosition = position * 0.6;

    return Alignment(adjustedPosition, 0);
  }
}
