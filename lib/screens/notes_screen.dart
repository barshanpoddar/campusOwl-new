import 'package:flutter/material.dart';
import '../constants.dart';
import 'note_detail_screen.dart';
import 'group_chat_screen.dart';
import '../widgets/custom_fab_button.dart';

class NotesScreen extends StatefulWidget {
  final GlobalKey<CustomFabButtonState>? fabKey;

  const NotesScreen({super.key, this.fabKey});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String activeTab = 'notes';
  Note? _selectedNote;
  Group? _selectedGroup;
  // use widget.fabKey if provided (allows parent to control FAB), otherwise private key
  late final GlobalKey<CustomFabButtonState> _fabKey = widget.fabKey ?? GlobalKey<CustomFabButtonState>();

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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _fabKey.currentState?.collapse(),
        child: Column(
          children: [
            // Top tabs: My Notes / Groups with an animated underline indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _fabKey.currentState?.collapse();
                            setState(() => activeTab = 'notes');
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8.0)),
                          child: Text(
                            'My Notes',
                            style: TextStyle(
                              color: activeTab == 'notes' ? Theme.of(context).primaryColor : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _fabKey.currentState?.collapse();
                            setState(() => activeTab = 'groups');
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8.0)),
                          child: Text(
                            'Groups',
                            style: TextStyle(
                              color: activeTab == 'groups' ? Theme.of(context).primaryColor : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // light divider and animated underline indicator beneath the active tab
                  Container(
                    height: 28,
                    child: Stack(
                      children: [
                        // subtle divider line
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(height: 1, color: Colors.grey.shade200),
                          ),
                        ),
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          alignment: activeTab == 'notes' ? const Alignment(-0.6, 0) : const Alignment(0.6, 0),
                          child: Container(
                            width: 80,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: activeTab == 'notes' ? _buildNotesList() : _buildGroupsList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFabButton(
        key: _fabKey,
        icon: Icons.add,
        svgAsset: 'assets/icons/add.svg',
        label: activeTab == 'notes' ? 'New Note' : 'New Group',
        onPressed: () {},
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.separated(
      itemCount: dummyNotes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final note = dummyNotes[index];
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
      itemCount: dummyGroups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final group = dummyGroups[index];
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
