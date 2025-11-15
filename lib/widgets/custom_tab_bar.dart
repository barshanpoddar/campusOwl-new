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

/// A custom reusable tab bar with underline indicator
/// Designed to match modern tab bar UI patterns (like in the reference image)
class CustomTabBar extends StatelessWidget {
  final List<CustomTabItem> tabs;
  final String activeTabId;
  final ValueChanged<String> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final double indicatorHeight;
  final EdgeInsets? padding;
  final bool showDivider;
  final TextStyle? activeTextStyle;
  final TextStyle? inactiveTextStyle;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.activeTabId,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.indicatorHeight = 2.5,
    this.padding,
    this.showDivider = true,
    this.activeTextStyle,
    this.inactiveTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.primaryColor;
    final effectiveInactiveColor = inactiveColor ?? Colors.grey.shade600;
    final effectiveIndicatorColor = indicatorColor ?? theme.primaryColor;

    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: tabs.asMap().entries.map((entry) {
              final tab = entry.value;
              final isActive = activeTabId == tab.id;

              return Expanded(
                child: InkWell(
                  onTap: () => onTabChanged(tab.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(width: 8),
                        ],
                        Text(
                          tab.label,
                          style: isActive
                              ? (activeTextStyle ??
                                  TextStyle(
                                    color: effectiveActiveColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ))
                              : (inactiveTextStyle ??
                                  TextStyle(
                                    color: effectiveInactiveColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // Animated indicator that slides to the active tab
          LayoutBuilder(
            builder: (context, constraints) {
              final total = tabs.length;
              final tabWidth = total > 0
                  ? constraints.maxWidth / total
                  : constraints.maxWidth;
              final activeIndex = tabs.indexWhere((t) => t.id == activeTabId);
              final left = (activeIndex >= 0 ? activeIndex : 0) * tabWidth;

              return SizedBox(
                height: indicatorHeight + (showDivider ? 1.0 : 0.0),
                child: Stack(
                  children: [
                    // Optional divider line (kept behind the indicator)
                    if (showDivider)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child:
                            Container(height: 1, color: Colors.grey.shade200),
                      ),

                    // Sliding indicator
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeInOut,
                      left: left,
                      width: tabWidth,
                      bottom: 0,
                      height: indicatorHeight,
                      child: Container(color: effectiveIndicatorColor),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
