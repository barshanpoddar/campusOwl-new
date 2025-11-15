import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_icon.dart';
import '../widgets/custom_fab_button.dart';

class GroupChatScreen extends StatefulWidget {
  final Group group;
  final VoidCallback onClose;

  const GroupChatScreen(
      {super.key, required this.group, required this.onClose});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<ChatMessage> _messages;
  OverlayEntry? _menuEntry;
  final GlobalKey<CustomFabButtonState> _fabKey =
      GlobalKey<CustomFabButtonState>();

  @override
  void initState() {
    super.initState();
    // dummyChats is a list of maps; find the map for this group id
    final map = dummyChats.firstWhere((m) => m.containsKey(widget.group.id),
        orElse: () => {});
    _messages = List<ChatMessage>.from(map[widget.group.id] ?? []);
  }

  void _showCustomMenu(Offset globalPosition) {
    // remove any existing
    _hideCustomMenu();

    final overlay = Overlay.of(context);

    final RenderBox overlayBox =
        overlay.context.findRenderObject() as RenderBox;
    final local = overlayBox.globalToLocal(globalPosition);

    _menuEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _hideCustomMenu,
          child: Stack(
            children: [
              Positioned(
                top: local.dy + 8,
                left: local.dx - 120,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8)
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuItem('View members', () {
                        _hideCustomMenu();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('View members (not implemented)')));
                      }),
                      _menuItem('Mute', () {
                        _hideCustomMenu();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Chat muted (not implemented)')));
                      }),
                      _menuItem('Leave group', () {
                        _hideCustomMenu();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Left group (not implemented)')));
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_menuEntry!);
  }

  void _hideCustomMenu() {
    _menuEntry?.remove();
    _menuEntry = null;
  }

  Widget _menuItem(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
        child: Text(text,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        sender: 'You',
        text: text,
        time: TimeOfDay.now().format(context),
        isRead: true);
    setState(() {
      _messages.add(msg);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarIconColor = Theme.of(context).appBarTheme.iconTheme?.color ??
        Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).iconTheme.color ??
        Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon:
                const AppIcon(assetName: 'arrow_left', icon: Icons.arrow_back),
            onPressed: widget.onClose),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.name),
            Text('${widget.group.members} members',
                style: const TextStyle(fontSize: 12))
          ],
        ),
        actions: [
          // Custom three-dot menu trigger (no Material icons)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _showCustomMenu(details.globalPosition),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: AppIcon(
                  assetName: 'menu',
                  size: 20,
                  color: appBarIconColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _fabKey.currentState?.collapse(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final m = _messages[index];
                  final isMe = m.sender == 'You';
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(m.sender,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(m.text,
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87)),
                          const SizedBox(height: 6),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(m.time,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: isMe ? Colors.white70 : Colors.grey))
                          ]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SizedBox(
                height: 60,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // small handle bar above input (visual)
                    Positioned(
                      top: -8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // Input pill
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(
                              right: 68), // leave space for send button
                          child: TextField(
                            controller: _controller,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Send button (circular) overlapping right
                    Positioned(
                      right: 6,
                      top: 8,
                      bottom: 8,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _send,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: AppIcon(
                            assetName: 'paper_airplane',
                            icon: Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
