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
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0);

    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: showDivider ? Colors.grey.shade200 : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: effectivePadding,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final tab = entry.value;
            final isActive = activeTabId == tab.id;

            return Expanded(
              child: InkWell(
                onTap: () => onTabChanged(tab.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isActive
                            ? effectiveIndicatorColor
                            : Colors.transparent,
                        width: indicatorHeight,
                      ),
                    ),
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
      ),
    );
  }
}
