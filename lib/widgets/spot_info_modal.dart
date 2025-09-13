import 'package:flutter/material.dart';
import '../models/models.dart';

class SpotInfoModal {
  static void show(
    BuildContext context,
    FishingSpot spot, {
    required VoidCallback onCenterOnSpot,
    required VoidCallback onQuickAddCatch,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (spot.comment?.trim().isNotEmpty == true)
              Text(spot.comment!),
            const SizedBox(height: 8),
            Text(
              'Lat: ${spot.lat.toStringAsFixed(5)}  •  Lng: ${spot.lng.toStringAsFixed(5)}',
              style: const TextStyle(fontFamily: 'monospace', color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text('${spot.catches.length} catch${spot.catches.length == 1 ? '' : 'es'}'),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    onCenterOnSpot();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.center_focus_strong),
                  label: const Text('Center'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () {
                    onQuickAddCatch();
                    Navigator.pop(context);
                  },
                  icon: const Text('🎣'),
                  label: const Text('Log Catch'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}