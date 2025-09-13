import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/location_service.dart';

class LocationSearchModal extends StatefulWidget {
  final Function(LocationSearchResult) onLocationSelected;

  const LocationSearchModal({
    super.key,
    required this.onLocationSelected,
  });

  static void show(
    BuildContext context,
    {required Function(LocationSearchResult) onLocationSelected}
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => LocationSearchModal(
        onLocationSelected: onLocationSelected,
      ),
    );
  }

  static IconData getLocationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'city':
      case 'town':
      case 'village':
        return Icons.location_city;
      case 'water':
      case 'natural':
        return Icons.water;
      case 'administrative':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  static String extractMainName(String displayName) {
    final parts = displayName.split(',');
    return parts.isNotEmpty ? parts[0].trim() : displayName;
  }

  @override
  State<LocationSearchModal> createState() => _LocationSearchModalState();
}

class _LocationSearchModalState extends State<LocationSearchModal> {
  final _searchController = TextEditingController();
  List<LocationSearchResult> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Search Location',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for cities, lakes, rivers...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : (_searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults.clear();
                            });
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null),
              border: const OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          if (_searchResults.isEmpty && !_isSearching && _searchController.text.isNotEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No locations found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else if (_searchController.text.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Search for fishing locations',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try searching for lakes, rivers, or cities',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        LocationSearchModal.getLocationIcon(result.type),
                        color: Colors.blue,
                      ),
                      title: Text(
                        LocationSearchModal.extractMainName(result.displayName),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        result.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        widget.onLocationSelected(result);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (value == _searchController.text) {
        final results = await LocationService.searchLocations(value);
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }
}