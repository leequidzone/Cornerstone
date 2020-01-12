// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      uid: json['uid'] as String,
      eventName: json['eventName'] as String,
      startTime: json['startTime'] as int,
      location:
          Location.fromJson(Map<String, String>.from(json['location'] as Map)),
      attendance: Map<String, bool>.from(json['attendance'] as Map));
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'uid': instance.uid,
      'eventName': instance.eventName,
      'startTime': instance.startTime,
      'attendance': instance.attendance,
      'location': instance.location
    };
