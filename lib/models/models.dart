// Location Search Models
class LocationSearchResult {
  final String displayName;
  final double lat;
  final double lng;
  final String? type;

  LocationSearchResult({
    required this.displayName,
    required this.lat,
    required this.lng,
    this.type,
  });

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    return LocationSearchResult(
      displayName: json['display_name'] ?? '',
      lat: double.parse(json['lat'] ?? '0'),
      lng: double.parse(json['lon'] ?? '0'),
      type: json['type'],
    );
  }
}

// Data Models
class FishingSpot {
  final int id;
  final String name;
  final String? comment;
  final double lat;
  final double lng;
  final List<CatchEntry> catches;

  FishingSpot({
    required this.id,
    required this.name,
    this.comment,
    required this.lat,
    required this.lng,
    List<CatchEntry>? catches,
  }) : catches = catches ?? [];
}

class CatchEntry {
  final int id;
  final int spotId;
  final String species;
  final String? size;
  final String? bait;
  final String? notes;
  final DateTime dateTime;

  CatchEntry({
    required this.id,
    required this.spotId,
    required this.species,
    this.size,
    this.bait,
    this.notes,
    required this.dateTime,
  });
}

class SpotDialogResult {
  final String name;
  final String? comment;

  SpotDialogResult({required this.name, this.comment});
}