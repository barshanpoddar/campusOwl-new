import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_icon.dart';
import 'note_detail_screen.dart';
import 'group_chat_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String activeTab = 'notes';
  Note? _selectedNote;
  Group? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    if (_selectedNote != null) {
      return NoteDetailScreen(note: _selectedNote!, onClose: () => setState(() => _selectedNote = null));
    }

    if (_selectedGroup != null) {
      return GroupChatScreen(group: _selectedGroup!, onClose: () => setState(() => _selectedGroup = null));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => activeTab = 'notes'),
                  child: Text('My Notes', style: TextStyle(color: activeTab == 'notes' ? Theme.of(context).primaryColor : Colors.grey)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => activeTab = 'groups'),
                  child: Text('Groups', style: TextStyle(color: activeTab == 'groups' ? Theme.of(context).primaryColor : Colors.grey)),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: activeTab == 'notes' ? _buildNotesList() : _buildGroupsList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const AppIcon(assetName: 'plus', icon: Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.separated(
      itemCount: DUMMY_NOTES.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final note = DUMMY_NOTES[index];
        return InkWell(
          onTap: () => setState(() => _selectedNote = note),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.subject, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('by ${note.author}', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Row(children: [Text('❤️ ${note.likes}'), const SizedBox(width: 12), Text('💬 ${note.comments}')]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsList() {
    return ListView.separated(
      itemCount: DUMMY_GROUPS.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final group = DUMMY_GROUPS[index];
        return InkWell(
          onTap: () => setState(() => _selectedGroup = group),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.subject, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${group.members} members', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        );
      },
    );
  }
}
