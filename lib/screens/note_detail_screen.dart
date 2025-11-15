import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_icon.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final VoidCallback onClose;

  const NoteDetailScreen({super.key, required this.note, required this.onClose});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool _loading = false;
  String? _aiResponse;

  Future<void> _simulateAi(String action) async {
    setState(() {
      _loading = true;
      _aiResponse = null;
    });
    // Simulate a small delay and produce a simple derived output.
    await Future.delayed(const Duration(milliseconds: 600));
    final content = widget.note.content;
    String result;
    if (action == 'summarize') {
      // take the first 3 lines-ish
      final lines = content.trim().split('\n').where((l) => l.trim().isNotEmpty).toList();
      result = lines.take(4).join('\n').trim();
    } else if (action == 'keyPoints') {
      final bullets = content
          .split(RegExp(r"[\n\-•]"))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .take(6)
          .map((s) => '• $s')
          .join('\n');
      result = bullets;
    } else {
      // explain
      result = 'In simple terms: ${content.split('.').first}.';
    }

    setState(() {
      _aiResponse = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const AppIcon(assetName: 'arrow_left', icon: Icons.arrow_back), onPressed: widget.onClose),
        title: Text(note.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(6)),
                    child: Text(note.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Text('by ${note.author}', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 12),
                  Text(note.content, style: const TextStyle(height: 1.4)),
                  const SizedBox(height: 24),
                  if (_aiResponse != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                      child: Text(_aiResponse!),
                    ),
                ],
              ),
            ),
          ),
          // Action buttons bar at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.summarize,
                  label: 'Summarize',
                  onTap: _loading ? null : () => _simulateAi('summarize'),
                  isActive: false,
                ),
                _buildActionButton(
                  icon: Icons.help_outline,
                  label: 'Explain',
                  onTap: _loading ? null : () => _simulateAi('explain'),
                  isActive: true,
                ),
                _buildActionButton(
                  icon: Icons.format_list_bulleted,
                  label: 'Key Points',
                  onTap: _loading ? null : () => _simulateAi('keyPoints'),
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final color = isActive ? theme.primaryColor : Colors.grey[600];
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_loading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                icon,
                size: 24,
                color: color,
              ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
