import 'package:flutter/material.dart';
import '../widgets/app_icon.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<int>? onSelectTab;

  const HomePage({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('CampusOwl', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Welcome — quick access to notes, gigs and focus tools.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _Tile(title: 'Notes', icon: Icons.note, asset: 'book_open', onTap: () => onSelectTab?.call(1)),
                    _Tile(title: 'Services', icon: Icons.room_service, asset: 'briefcase', onTap: () => onSelectTab?.call(2)),
                    _Tile(title: 'Jobs', icon: Icons.work, asset: 'briefcase', onTap: () => onSelectTab?.call(3)),
                    _Tile(title: 'Focus', icon: Icons.timer, asset: 'clock', onTap: () => onSelectTab?.call(4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(child: Text('Tap any tile or use the bottom navigation.', style: TextStyle(color: Colors.grey[600]))),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}


class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? asset;
  final VoidCallback? onTap;

  const _Tile({required this.title, required this.icon, this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            AppIcon(assetName: asset, icon: icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
