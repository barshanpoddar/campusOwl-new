import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomFabButton extends StatefulWidget {
  final IconData icon;
  final String? svgAsset;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const CustomFabButton({
    super.key,
    required this.icon,
    this.svgAsset,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF2563EB),
    this.foregroundColor = Colors.white,
  });

  @override
  State<CustomFabButton> createState() => CustomFabButtonState();
}
class CustomFabButtonState extends State<CustomFabButton>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    // call the provided callback only when the user explicitly taps the button
    widget.onPressed();
  }

  /// Collapse the FAB if it's expanded. Safe to call from parents.
  void collapse() {
    if (!isExpanded) return;
    setState(() {
      isExpanded = false;
      _controller.reverse();
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        height: 56,
        width: isExpanded ? 200 : 56, // Adjust width for expanded state
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isExpanded ? 16 : 28), // Rounded when collapsed, less when expanded
            ),
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 0.3),
          ),
          onPressed: _toggleExpansion,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // If an SVG asset is provided prefer it (tintable). Otherwise fall back to Icon.
                    if (widget.svgAsset != null)
                      SvgPicture.asset(
                        widget.svgAsset!,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(widget.foregroundColor, BlendMode.srcIn),
                      )
                    else
                      Icon(widget.icon, size: 20),
                    SizedBox(width: _animation.value * 8), // Spacing animation
                    if (_animation.value > 0.5)
                      Text(
                        widget.label,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
