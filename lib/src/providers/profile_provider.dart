//AutoGenerated:
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileProvider {
  Profile _profile;
  List<Profile> _profiles;
  Map<String, Profile> _profileMap;
  Profile profile(String uid) => _profileMap[uid];
  List<Profile> profiles() => _profiles;
}
