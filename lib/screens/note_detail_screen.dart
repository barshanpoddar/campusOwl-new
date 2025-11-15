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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : () => _simulateAi('summarize'),
                  icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const AppIcon(assetName: 'book_open', icon: Icons.description),
                  label: const Text('Summarize'),
                ),
                ElevatedButton.icon(
                  onPressed: _loading ? null : () => _simulateAi('explain'),
                  icon: const AppIcon(assetName: 'question_mark_circle', icon: Icons.help_outline),
                  label: const Text('Explain'),
                ),
                ElevatedButton.icon(
                  onPressed: _loading ? null : () => _simulateAi('keyPoints'),
                  icon: const AppIcon(assetName: 'list_bullet', icon: Icons.list),
                  label: const Text('Key Points'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
