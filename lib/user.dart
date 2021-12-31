import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  User({
    required this.id,
    required this.displayName,
    required this.login,
    this.email,
    this.description,
    this.profileImageUrl,
    this.offlineImageUrl,
    this.type,
    this.broadcasterType,
    this.viewCount,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String displayName;
  String login;
  String? email;
  String? description;
  String? profileImageUrl;
  String? offlineImageUrl;
  String? type;
  String? broadcasterType;
  int? viewCount;
  String? createdAt;
  String? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
