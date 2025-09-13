import 'package:flutter/material.dart';
import '../models/models.dart';

// Global data store (in-memory storage)
class AppData extends ChangeNotifier {
  final List<FishingSpot> _spots = [];
  final List<CatchEntry> _catches = [];

  List<FishingSpot> get spots => _spots;
  List<CatchEntry> get catches => _catches;

  void addSpot(FishingSpot spot) {
    _spots.add(spot);
    notifyListeners();
  }

  void addCatch(CatchEntry catch_) {
    _catches.add(catch_);
    // Find the spot and add the catch to it
    final spot = _spots.firstWhere((s) => s.id == catch_.spotId);
    spot.catches.insert(0, catch_);
    notifyListeners();
  }
}