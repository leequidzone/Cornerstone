// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sermon _$SermonFromJson(Map<String, dynamic> json) {
  return Sermon(
      date: json['date'] as String,
      path: json['path'] as String,
      created: json['created'] as int,
      title: json['title'] as String,
      verse: json['verse'] as String);
}

Map<String, dynamic> _$SermonToJson(Sermon instance) => <String, dynamic>{
      'created': instance.created,
      'date': instance.date,
      'path': instance.path,
      'title': instance.title,
      'verse': instance.verse
    };
