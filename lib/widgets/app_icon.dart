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

  const AppIcon({Key? key, this.assetName, this.icon, this.size = 24, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (assetName == null) {
      return Icon(icon ?? Icons.circle, size: size, color: color);
    }

    final svgPath = 'assets/icons/$assetName.svg';
    final pngPath = 'assets/icons/$assetName.png';

    return FutureBuilder<String?>(
      future: _findExistingAsset(svgPath, pngPath),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          final path = snap.data;
          if (path == null) return Icon(icon ?? Icons.circle, size: size, color: color);
          if (path.endsWith('.svg')) {
            return SvgPicture.asset(path, width: size, height: size, color: color);
          }
          return Image.asset(path, width: size, height: size, color: color);
        }

        // Keep layout stable while resolving asset.
        return SizedBox(width: size, height: size);
      },
    );
  }

  Future<String?> _findExistingAsset(String svg, String png) async {
    try {
      await rootBundle.load(svg);
      return svg;
    } catch (_) {
      // ignore
    }
    try {
      await rootBundle.load(png);
      return png;
    } catch (_) {
      return null;
    }
  }
}
