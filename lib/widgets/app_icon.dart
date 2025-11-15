import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Asset-aware icon widget.
///
/// Usage: `AppIcon(assetName: 'clock', icon: Icons.timer, size: 24, color: ...)`
/// It will attempt to load `assets/icons/clock.svg`, then `assets/icons/clock.png`.
/// If neither asset exists it falls back to the provided IconData (or a circle).
class AppIcon extends StatefulWidget {
  final String? assetName; // without extension
  final IconData? icon;
  final double size;
  final Color? color;

  const AppIcon(
      {super.key, this.assetName, this.icon, this.size = 24, this.color});

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {

  @override
  void initState() {
    super.initState();
    _resolveIfNeeded();
  }

  @override
  void didUpdateWidget(covariant AppIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the assetName changed, re-resolve. If theme changes, we don't want
    // to briefly replace the widget with an empty box — AnimatedSwitcher will
    // smoothly rebuild with updated color.
    if (oldWidget.assetName != widget.assetName) {
      _resolveIfNeeded();
    }
  }

  void _resolveIfNeeded() {
    final assetName = widget.assetName;
    if (assetName == null) return;
    final svgPath = 'assets/icons/$assetName.svg';
    final pngPath = 'assets/icons/$assetName.png';

    if (_assetCache.containsKey(svgPath)) {
      // cache already populated; trigger rebuild to pick up cached value
      setState(() {});
      return;
    }

    // trigger async lookup; when finished update state so AnimatedSwitcher can
    // cross-fade from the invisible placeholder to the real icon.
    _findExistingAsset(svgPath, pngPath).then((p) {
      if (!mounted) return;
      // trigger rebuild so build() reads the cache and shows the asset
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    // If no assetName provided, show the icon (honor color)
    if (widget.assetName == null) {
      return Icon(widget.icon ?? Icons.circle, size: size, color: widget.color);
    }

    Widget child;
    if (_assetCache.containsKey('assets/icons/${widget.assetName}.svg')) {
      final path = _assetCache['assets/icons/${widget.assetName}.svg'];
      if (path == null) {
        // explicit cached miss — show an invisible placeholder to keep layout
        child = Icon(widget.icon ?? Icons.circle,
            size: size, color: Colors.transparent);
      } else if (path.endsWith('.svg')) {
        child = SvgPicture.asset(path,
            key: ValueKey(path + (Theme.of(context).brightness.toString())),
            width: size,
            height: size,
            colorFilter:
                ColorFilter.mode(widget.color ?? Colors.black, BlendMode.srcIn));
      } else {
        child = Image.asset(path,
            key: ValueKey(path + (Theme.of(context).brightness.toString())),
            width: size,
            height: size,
            color: widget.color);
      }
    } else {
      // Not resolved yet: keep layout but avoid any visible 'box' by using a
      // transparent icon. AnimatedSwitcher will cross-fade when the asset
      // appears.
      child = Icon(widget.icon ?? Icons.circle,
          size: size, color: Colors.transparent);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: SizedBox(width: size, height: size, child: Center(child: child)),
    );
  }

  // Cache asset existence lookups to avoid repeated rootBundle.load calls which
  // can be slow when many icons are built repeatedly.
  static final Map<String, String?> _assetCache = {};

  Future<String?> _findExistingAsset(String svg, String png) async {
    final key = svg; // svg path is unique per assetName
    if (_assetCache.containsKey(key)) return _assetCache[key];

    try {
      await rootBundle.load(svg);
      _assetCache[key] = svg;
      return svg;
    } catch (_) {
      // ignore
    }
    try {
      await rootBundle.load(png);
      _assetCache[key] = png;
      return png;
    } catch (_) {
      _assetCache[key] = null;
      return null;
    }
  }
}
