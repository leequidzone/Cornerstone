//AutoGenerated:
import 'package:flutter/material.dart';
import '../models/location.dart';

class LocationProvider {
  Location _location;
  List<Location> _locations;
  Map<String, Location> _locationMap;
  Location location(String uid) => _locationMap[uid];
  List<Location> locations() => _locations;
}
