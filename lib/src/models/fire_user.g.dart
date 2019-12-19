// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fire_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireUser _$FireUserFromJson(Map<String, dynamic> json) {
  return FireUser(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      isEmailVerified: json['isEmailVerified'] as String,
      phoneNumber: json['phoneNumber'] as String,
      photoUrl: json['photoUrl'] as String,
      providerId: json['providerId'] as String,
      isAnonymous: json['isAnonymous'] as String,
      email: json['email'] as String,
      hasProfile: json['hasProfile'] as String,
      profile: json['profile'] as String);
}

Map<String, dynamic> _$FireUserToJson(FireUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'isEmailVerified': instance.isEmailVerified,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'providerId': instance.providerId,
      'isAnonymous': instance.isAnonymous,
      'email': instance.email,
      'hasProfile': instance.hasProfile,
      'profile': instance.profile
    };
