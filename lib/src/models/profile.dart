//AutoGenerated:
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(nullable: false)
class Profile {
  final String uid;
  Profile({this.uid});
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
