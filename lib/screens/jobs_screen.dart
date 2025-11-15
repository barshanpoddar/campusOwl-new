import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_icon.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String query = '';
  bool showFilters = false;
  String sortBy = 'default';
  List<String> selectedTypes = [];

  List<Job> get filtered {
    var list = dummyJobs
        .where((j) => j.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (selectedTypes.isNotEmpty) {
      list = list.where((j) => selectedTypes.contains(j.type)).toList();
    }
    if (sortBy == 'highestpaying') {
      list.sort((a, b) => a.pay.compareTo(b.pay));
    } else if (sortBy == 'toprated') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  void _toggleType(String type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobTypes = dummyJobs.map((j) => j.type).toSet().toList();
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            Expanded(
              child: TextField(
                decoration:
                    const InputDecoration(hintText: 'Search for jobs...')
                        .copyWith(
                            prefixIcon: const AppIcon(
                                assetName: 'search', icon: Icons.search)),
                onChanged: (v) => setState(() => query = v),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
                icon: const AppIcon(
                    assetName: 'adjustments_horizontal',
                    icon: Icons.filter_list),
                onPressed: () => setState(() => showFilters = !showFilters)),
          ]),
        ),
        if (showFilters)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Column(children: [
              Wrap(
                  spacing: 8,
                  children: jobTypes
                      .map((t) => ChoiceChip(
                          label: Text(t),
                          selected: selectedTypes.contains(t),
                          onSelected: (_) => _toggleType(t)))
                      .toList()),
              const SizedBox(height: 8),
              Row(children: [
                const Text('Sort:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                    value: sortBy,
                    items: const [
                      DropdownMenuItem(
                          value: 'default', child: Text('Default')),
                      DropdownMenuItem(
                          value: 'highestpaying',
                          child: Text('Highest Paying')),
                      DropdownMenuItem(
                          value: 'toprated', child: Text('Top Rated'))
                    ],
                    onChanged: (v) => setState(() => sortBy = v ?? 'default'))
              ])
            ]),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final job = filtered[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(job.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(job.type))
                          ]),
                      const SizedBox(height: 8),
                      Text(job.location),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(job.pay,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Row(children: [
                              const AppIcon(
                                  assetName: 'star',
                                  icon: Icons.star,
                                  color: Colors.yellow),
                              Text(job.rating.toString())
                            ])
                          ])
                    ]),
              );
            },
          ),
        )
      ]),
    );
  }
}
