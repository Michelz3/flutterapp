import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import '../widgets/info_card.dart';
import 'main_navigation_page.dart';

class SpotsPage extends StatelessWidget {
  const SpotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎣 Fishing Spots'),
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          if (appData.spots.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoCard(
                    icon: Icons.info_outline,
                    title: 'Tip',
                    subtitle: 'Go to the Map tab, tap on the map to place a blue pin, then press "Add spot at pin" to create your first spot.',
                  ),
                  const SizedBox(height: 16),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No fishing spots yet',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appData.spots.length,
            itemBuilder: (context, index) {
              final spot = appData.spots[index];
              final catchCount = spot.catches.length;
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              spot.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (catchCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '$catchCount catch${catchCount == 1 ? '' : 'es'}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      if (spot.comment?.trim().isNotEmpty == true) ...[
                        const SizedBox(height: 6),
                        Text(
                          spot.comment!,
                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Lat: ${spot.lat.toStringAsFixed(5)}  •  Lng: ${spot.lng.toStringAsFixed(5)}',
                        style: const TextStyle(fontFamily: 'monospace', color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              // Navigate to map tab and center on spot
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainNavigationPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('View on Map'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}