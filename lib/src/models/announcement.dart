//AutoGenerated:
import 'package:json_annotation/json_annotation.dart';
part 'announcement.g.dart';

@JsonSerializable(nullable: false)
class Announcement {
  final int created;
  final String userId;
  final String uid;
  final String text;

  Announcement({this.uid, this.userId, this.created, this.text});

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}