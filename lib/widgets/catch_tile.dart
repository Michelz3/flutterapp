import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class CatchTile extends StatelessWidget {
  final CatchEntry catchEntry; // Renamed from 'catch' to 'catchEntry'

  const CatchTile({
    super.key,
    required this.catchEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                catchEntry.species, // Updated reference
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${DateFormat.yMMMd().format(catchEntry.dateTime)} • ${DateFormat.Hm().format(catchEntry.dateTime)}', // Updated reference
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              if (catchEntry.size?.trim().isNotEmpty == true) // Updated reference
                _buildChip('Size', catchEntry.size!),
              if (catchEntry.bait?.trim().isNotEmpty == true) // Updated reference
                _buildChip('Bait', catchEntry.bait!),
            ],
          ),
          if (catchEntry.notes?.trim().isNotEmpty == true) ...[ // Updated reference
            const SizedBox(height: 6),
            Text(catchEntry.notes!),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text('$label: $value'),
    );
  }
}