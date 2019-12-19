// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      dob: json['dob'] as String,
      address: json['address'] as String,
      address1: json['address1'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zip: json['zip'] as String,
      uid: json['uid'] as String,
      role: json['role'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'dob': instance.dob,
      'address': instance.address,
      'address1': instance.address1,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'role': instance.role
    };
