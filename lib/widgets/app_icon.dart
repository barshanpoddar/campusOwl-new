import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Asset-aware icon widget.
///
/// Usage: `AppIcon(assetName: 'clock', icon: Icons.timer, size: 24, color: ...)`
/// It will attempt to load `assets/icons/clock.svg`, then `assets/icons/clock.png`.
/// If neither asset exists it falls back to the provided IconData (or a circle).
class AppIcon extends StatelessWidget {
  final String? assetName; // without extension
  final IconData? icon;
  final double size;
  final Color? color;

  const AppIcon(
      {super.key, this.assetName, this.icon, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    if (assetName == null) {
      return Icon(icon ?? Icons.circle, size: size, color: color);
    }

    final svgPath = 'assets/icons/$assetName.svg';
    final pngPath = 'assets/icons/$assetName.png';
    // If we have a cached result, use it synchronously to avoid flicker when
    // theme changes (FutureBuilder would briefly show the fallback Icon while
    // waiting for the future). If the cache has no entry yet, trigger the
    // async lookup but render an empty fixed-size box to keep layout stable
    // and avoid showing the placeholder icon.
    final cached = _assetCache[svgPath];
    if (_assetCache.containsKey(svgPath)) {
      final path = cached;
      if (path == null) return Icon(icon ?? Icons.circle, size: size, color: color);
      if (path.endsWith('.svg')) {
        return SvgPicture.asset(path,
            width: size,
            height: size,
            colorFilter:
                ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn));
      }
      return Image.asset(path, width: size, height: size, color: color);
    }

    // Not cached: start async lookup but don't show the fallback icon to avoid
    // the 'box placeholder' flash during theme toggles. Use a SizedBox to keep
    // layout consistent. The lookup will populate the cache for subsequent
    // builds.
    _findExistingAsset(svgPath, pngPath);
    return SizedBox(width: size, height: size);
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
