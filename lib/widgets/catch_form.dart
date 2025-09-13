import 'package:flutter/material.dart';
import '../models/models.dart';

class CatchForm extends StatefulWidget {
  final List<FishingSpot> spots;
  final FishingSpot? selectedSpot;
  final Function(FishingSpot?) onSelectedSpotChanged;
  final Function(CatchEntry) onCatchAdded;

  const CatchForm({
    super.key,
    required this.spots,
    this.selectedSpot,
    required this.onSelectedSpotChanged,
    required this.onCatchAdded,
  });

  @override
  State<CatchForm> createState() => _CatchFormState();
}

class _CatchFormState extends State<CatchForm> {
  final _speciesCtrl = TextEditingController();
  final _sizeCtrl = TextEditingController();
  final _baitCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _speciesCtrl.dispose();
    _sizeCtrl.dispose();
    _baitCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline),
                const SizedBox(width: 8),
                Text(
                  'Log New Catch',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<FishingSpot>(
                    value: widget.selectedSpot,
                    decoration: const InputDecoration(
                      labelText: 'Select Fishing Spot',
                      border: OutlineInputBorder(),
                    ),
                    items: widget.spots
                        .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                        .toList(),
                    onChanged: widget.onSelectedSpotChanged,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _speciesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Fish Species',
                      hintText: 'e.g., Bass, Trout, Pike',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _sizeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Size/Weight',
                      hintText: 'e.g., 2.5 lbs, 15 inches',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _baitCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bait/Lure Used',
                      hintText: 'e.g., Worms, Spinner, Jig',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Weather conditions, time of day, etc.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _addCatch,
                    child: const Text('Log Catch'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCatch() {
    if (widget.selectedSpot == null) {
      _showSnackBar('Please select a fishing spot first');
      return;
    }

    if (_speciesCtrl.text.trim().isEmpty) {
      _showSnackBar('Please enter the fish species');
      return;
    }

    final newCatch = CatchEntry(
      id: DateTime.now().millisecondsSinceEpoch,
      spotId: widget.selectedSpot!.id,
      species: _speciesCtrl.text.trim(),
      dateTime: DateTime.now(),
      size: _sizeCtrl.text.trim().isEmpty ? null : _sizeCtrl.text.trim(),
      bait: _baitCtrl.text.trim().isEmpty ? null : _baitCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    widget.onCatchAdded(newCatch);
    
    // Clear the form
    _speciesCtrl.clear();
    _sizeCtrl.clear();
    _baitCtrl.clear();
    _notesCtrl.clear();

    _showSnackBar('Catch logged successfully!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}