// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) {
  return Announcement(
      uid: json['uid'] as String,
      userId: json['userId'] as String,
      created: json['created'] as int,
      text: json['text'] as String);
}

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'created': instance.created,
      'userId': instance.userId,
      'uid': instance.uid,
      'text': instance.text
    };
