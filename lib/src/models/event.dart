//AutoGenerated:
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import './location.dart';
part 'event.g.dart';

@JsonSerializable(nullable: false)
class Event {
  final String uid;
  final int created;
  final int startTime;
  final Location location;
  Event({this.uid, this.created, this.startTime, this.location});
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
