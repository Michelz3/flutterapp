import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../providers/app_data.dart';
import '../widgets/catch_tile.dart';

class LogbookPage extends StatelessWidget {
  const LogbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📖 Logbook'),
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  'Catch History by Spots',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (appData.spots.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('No fishing spots created yet.',
                          style: TextStyle(color: Colors.black54)),
                    ),
                  )
                else
                  ...appData.spots.map(_spotLogbookTile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _spotLogbookTile(FishingSpot spot) {
    final lastCatchDate = spot.catches.isNotEmpty
        ? DateFormat.yMMMd().format(spot.catches.first.dateTime)
        : null;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.place_outlined),
        title: Text(spot.name),
        subtitle: Text(
          [
            if (spot.comment?.trim().isNotEmpty == true) spot.comment!,
            lastCatchDate != null ? 'Last catch: $lastCatchDate' : 'No catches yet',
          ].join(' • '),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (spot.catches.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('No catches logged for this spot yet.',
                  style: TextStyle(color: Colors.black54)),
            )
          else
            ...spot.catches.map((c) => CatchTile(catchEntry: c)).toList(),
        ],
      ),
    );
  }
}