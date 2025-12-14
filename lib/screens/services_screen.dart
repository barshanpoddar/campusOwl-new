import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_icon.dart';
import '../widgets/custom_fab_button.dart';
import '../widgets/custom_tab_bar.dart';

class ServicesScreen extends StatefulWidget {
  final GlobalKey<CustomFabButtonState>? fabKey;

  const ServicesScreen({super.key, this.fabKey});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String activeTab = 'mess';
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
                CustomTabItem(id: 'mess', label: 'Mess'),
                CustomTabItem(id: 'tiffin', label: 'Tiffin'),
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
                child:
                    activeTab == 'mess' ? _buildMessList() : _buildTiffinList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFabButton(
        key: _fabKey,
        icon: Icons.add,
        svgAsset: 'assets/icons/add.svg',
        label: 'Add Service',
        onPressed: () {},
      ),
    );
  }

  Widget _buildMessList() {
    return ListView.separated(
      itemCount: dummyMesses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final m = dummyMesses[index];
        return InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MessDetailScreen(mess: m))),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(m.cuisine, style: TextStyle(color: Colors.grey[600]))
                ]),
                Column(children: [
                  Row(children: [
                    const AppIcon(
                        assetName: 'star',
                        icon: Icons.star,
                        color: Colors.yellow),
                    Text(m.rating.toStringAsFixed(1))
                  ]),
                  Text(m.distance)
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTiffinList() {
    return ListView.separated(
      itemCount: dummyTiffins.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final t = dummyTiffins[index];
        return InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => TiffinDetailScreen(tiffin: t))),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(t.cuisine,
                            style: TextStyle(color: Colors.grey[600]))
                      ]),
                  Column(children: [
                    Row(children: [
                      const AppIcon(
                          assetName: 'star',
                          icon: Icons.star,
                          color: Colors.yellow),
                      Text(t.rating.toStringAsFixed(1))
                    ]),
                    Text(t.distance)
                  ])
                ]),
          ),
        );
      },
    );
  }
}

class MessDetailScreen extends StatelessWidget {
  final Mess mess;
  const MessDetailScreen({super.key, required this.mess});

  @override
  Widget build(BuildContext context) {
    // menu days available in mess.menu
    return Scaffold(
      appBar: AppBar(title: Text(mess.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mess.images.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.network(mess.images[index],
                      width: MediaQuery.of(context).size.width - 60,
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(mess.cuisine, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(mess.rating.toStringAsFixed(1)),
              Text(mess.distance)
            ]),
            const SizedBox(height: 12),
            Text(mess.description),
            const SizedBox(height: 12),
            const Text('Weekly Menu',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...mess.menu.entries.take(3).map((e) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.key,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Lunch: ${e.value['Lunch']?.join(', ')}'),
                  Text('Dinner: ${e.value['Dinner']?.join(', ')}'),
                  const SizedBox(height: 8)
                ])),
            const SizedBox(height: 12),
            const Text('Reviews',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...mess.reviews.map((r) => ListTile(
                title: Text(r.author),
                subtitle: Text(r.comment),
                trailing: Text(r.rating.toString()))),
          ]),
        ),
      ),
    );
  }
}

class TiffinDetailScreen extends StatelessWidget {
  final Tiffin tiffin;
  const TiffinDetailScreen({super.key, required this.tiffin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tiffin.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                height: 140,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tiffin.images.length,
                    itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(tiffin.images[i],
                            width: MediaQuery.of(context).size.width - 60,
                            fit: BoxFit.cover)))),
            const SizedBox(height: 12),
            Text(tiffin.cuisine, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(tiffin.description),
            const SizedBox(height: 12),
            const Text('How it works',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...tiffin.howItWorks.map((s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('• $s'))),
            const SizedBox(height: 12),
            const Text('Plans', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...tiffin.plans.map((p) =>
                ListTile(title: Text(p['name']), trailing: Text(p['price']))),
          ]),
        ),
      ),
    );
  }
}
