import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_data.dart';
import '../widgets/catch_form.dart';
import '../widgets/location_search_modal.dart';
import '../widgets/spot_info_modal.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Map state
  latlng.LatLng _mapCenter = latlng.LatLng(52.03136, 6.0605); // Utrecht default
  latlng.LatLng? _latestPicked; // latest pin position from taps

  // Catch logging state
  bool _showCatchForm = false;
  FishingSpot? _selectedSpotForCatch;

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎣 Fishing Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showLocationSearch,
            tooltip: 'Search Location',
          ),
          IconButton(
            icon: Icon(_showCatchForm ? Icons.close : Icons.add_circle_outline),
            onPressed: () {
              setState(() {
                _showCatchForm = !_showCatchForm;
                if (!_showCatchForm) {
                  _selectedSpotForCatch = null;
                }
              });
            },
            tooltip: _showCatchForm ? 'Close Catch Form' : 'Log Catch',
          ),
        ],
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          return Row(
            children: [
              Expanded(child: _buildMap(appData)),
              if (_showCatchForm) ...[
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 350,
                  child: CatchForm(
                    spots: appData.spots,
                    selectedSpot: _selectedSpotForCatch,
                    onSelectedSpotChanged: (spot) {
                      setState(() {
                        _selectedSpotForCatch = spot;
                      });
                    },
                    onCatchAdded: (catch_) {
                      appData.addCatch(catch_);
                      setState(() {
                        _showCatchForm = false;
                        _selectedSpotForCatch = null;
                      });
                      _snack('Catch logged for ${appData.spots.firstWhere((s) => s.id == catch_.spotId).name}!');
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(AppData appData) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _mapCenter,
            initialZoom: 12,
            onTap: (tapPosition, point) {
              setState(() {
                _latestPicked = point;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                // Saved fishing spots
                for (final spot in appData.spots)
                  Marker(
                    point: latlng.LatLng(spot.lat, spot.lng),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showSpotInfo(spot),
                      child: const Icon(Icons.location_on, color: Colors.red, size: 36),
                    ),
                  ),
                // Temporary pin for adding a new spot
                if (_latestPicked != null)
                  Marker(
                    point: _latestPicked!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.push_pin, color: Colors.blue, size: 32),
                  ),
              ],
            ),
          ],
        ),
        // Add spot button positioned in bottom right corner
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _onAddSpotPressed(appData),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Add spot at pin'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  void _showSpotInfo(FishingSpot spot) {
    SpotInfoModal.show(
      context,
      spot,
      onCenterOnSpot: () => _centerOnSpot(spot),
      onQuickAddCatch: () => _quickAddCatch(spot),
    );
  }

  void _centerOnSpot(FishingSpot spot) {
    setState(() {
      _mapCenter = latlng.LatLng(spot.lat, spot.lng);
    });
    _mapController.move(latlng.LatLng(spot.lat, spot.lng), 15);
    _snack('Centered on ${spot.name}');
  }

  void _quickAddCatch(FishingSpot spot) {
    setState(() {
      _selectedSpotForCatch = spot;
      _showCatchForm = true;
    });
    _snack('Ready to log catch for ${spot.name}');
  }

  Future<void> _onAddSpotPressed(AppData appData) async {
    final picked = _latestPicked;
    if (picked == null) {
      _snack('Tap on the map to drop a pin first, then try again.');
      return;
    }

    final nameCtrl = TextEditingController();
    final commentCtrl = TextEditingController();

    final result = await showDialog<SpotDialogResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Fishing Spot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Spot Name',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentCtrl,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description/Comments',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lat: ${picked.latitude.toStringAsFixed(5)}, Lng: ${picked.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(
                  context,
                  SpotDialogResult(
                    name: nameCtrl.text.trim(),
                    comment: commentCtrl.text.trim(),
                  ),
                );
              },
              child: const Text('Save Spot'),
            ),
          ],
        );
      },
    );

    if (result == null) return;

    final spot = FishingSpot(
      id: DateTime.now().millisecondsSinceEpoch,
      name: result.name,
      comment: result.comment?.isEmpty == true ? null : result.comment,
      lat: picked.latitude,
      lng: picked.longitude,
    );

    appData.addSpot(spot);
    setState(() {
      _latestPicked = null; // Clear the temporary pin
    });

    _snack('Added fishing spot: ${spot.name}');
  }

  void _showLocationSearch() {
    LocationSearchModal.show(
      context,
      onLocationSelected: (location) => _navigateToLocation(location),
    );
  }

  void _navigateToLocation(LocationSearchResult location) {
    final latLng = latlng.LatLng(location.lat, location.lng);
    
    setState(() {
      _mapCenter = latLng;
      _latestPicked = latLng; // Set as potential spot location
    });
    
    _mapController.move(latLng, 14);
    
    _snack('Navigated to ${LocationSearchModal.extractMainName(location.displayName)}');
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}