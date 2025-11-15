import 'package:flutter/material.dart';
import '../constants.dart';
import 'note_detail_screen.dart';
import 'group_chat_screen.dart';
import '../widgets/custom_fab_button.dart';
import '../widgets/custom_tab_bar.dart';

class NotesScreen extends StatefulWidget {
  final GlobalKey<CustomFabButtonState>? fabKey;

  const NotesScreen({super.key, this.fabKey});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String activeTab = 'notes';
  // use widget.fabKey if provided (allows parent to control FAB), otherwise private key
  late final GlobalKey<CustomFabButtonState> _fabKey =
      widget.fabKey ?? GlobalKey<CustomFabButtonState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _fabKey.currentState?.collapse(),
        child: Column(
          children: [
            CustomTabBar(
              tabs: const [
                CustomTabItem(id: 'notes', label: 'My Notes'),
                CustomTabItem(id: 'groups', label: 'Groups'),
              ],
              activeTabId: activeTab,
              onTabChanged: (tabId) {
                _fabKey.currentState?.collapse();
                setState(() => activeTab = tabId);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: activeTab == 'notes'
                    ? _buildNotesList()
                    : _buildGroupsList(),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteDetailScreen(
                note: note,
                onClose: () => Navigator.pop(context),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.subject,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('by ${note.author}',
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Row(children: [
                  Text('❤️ ${note.likes}'),
                  const SizedBox(width: 12),
                  Text('💬 ${note.comments}')
                ]),
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => GroupChatScreen(
                      group: group, onClose: () => Navigator.pop(context)))),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.subject,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(group.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${group.members} members',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        );
      },
    );
  }
}
