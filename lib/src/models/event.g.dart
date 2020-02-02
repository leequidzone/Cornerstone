// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      id: json['id'] as String,
      eventName: json['eventName'] as String,
      startTime: json['startTime'] as int,
      city: json['city'] as String,
      state: json['state'] as String,
      street: json['street'] as String,
      zip: json['zip'] as String,
      attendance: Map<String, bool>.from(json['attendance'] as Map));
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'eventName': instance.eventName,
      'startTime': instance.startTime,
      'attendance': instance.attendance,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip
    };
