// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      uid: json['uid'] as String,
      created: json['created'] as int,
      startTime: json['startTime'] as int,
      location: Location.fromJson(json['location'] as Map<String, dynamic>));
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'uid': instance.uid,
      'created': instance.created,
      'startTime': instance.startTime,
      'location': instance.location
    };
