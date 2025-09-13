import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class LocationService {
  static Future<List<LocationSearchResult>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final url = 'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5&addressdetails=1';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'FishingApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => LocationSearchResult.fromJson(item)).toList();
      }
    } catch (e) {
      print('Search error: $e');
    }
    
    return [];
  }
}