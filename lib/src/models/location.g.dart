// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
      uid: json['uid'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String,
      address3: json['address3'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zip: json['zip'] as String,
      lat: json['lat'] as String,
      long: json['long'] as String);
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'uid': instance.uid,
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'lat': instance.lat,
      'long': instance.long
    };
