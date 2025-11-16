import 'package:flutter/material.dart';
import 'app_icon.dart';

/// A horizontal streak indicator showing completed days with an animated,
/// theme-aware set of icon pills.
///
/// Example:
/// StreakBar(total: 7, current: 3)
class StreakBar extends StatelessWidget {
  final int total;
  final int current;
  final double size;
  final String assetName;
  final Color? activeColor;
  final Color? inactiveColor;

  const StreakBar({
    super.key,
    required this.total,
    required this.current,
    this.size = 40,
    this.assetName = 'bolt',
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? Colors.orange;
    final inactive = inactiveColor ?? Colors.grey.shade300;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(total, (index) {
        final done = index < current;
        return _StreakPill(
          size: size,
          done: done,
          assetName: assetName,
          activeColor: active,
          inactiveColor: inactive,
          semanticLabel: 'Day ${index + 1} ${done ? 'completed' : 'not completed'}',
        );
      }),
    );
  }
}

class _StreakPill extends StatelessWidget {
  final double size;
  final bool done;
  final String assetName;
  final Color activeColor;
  final Color inactiveColor;
  final String semanticLabel;

  const _StreakPill({
    required this.size,
    required this.done,
    required this.assetName,
    required this.activeColor,
    required this.inactiveColor,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Animate scale and background color when toggling.
    return Tooltip(
      message: semanticLabel,
      child: Semantics(
        label: semanticLabel,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: done ? 1.06 : 1.0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: done ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(size * 0.32),
                  border: done
                      ? null
                      : Border.all(color: inactiveColor, width: 1.5),
                  boxShadow: done
                      ? [
                          BoxShadow(
                            color: activeColor.withAlpha(51),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: AppIcon(
                    assetName: assetName,
                    size: size * 0.56,
                    // when done, icon is white for contrast; otherwise use
                    // the inactiveColor to match outline.
                    color: done ? Colors.white : inactiveColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
