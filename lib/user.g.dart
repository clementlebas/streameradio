// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      login: json['login'] as String,
      email: json['email'] as String?,
      description: json['description'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      offlineImageUrl: json['offline_image_url'] as String?,
      type: json['type'] as String?,
      broadcasterType: json['broadcaster_type'] as String?,
      viewCount: json['view_count'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'login': instance.login,
      'email': instance.email,
      'description': instance.description,
      'profile_image_url': instance.profileImageUrl,
      'offline_image_url': instance.offlineImageUrl,
      'type': instance.type,
      'broadcaster_type': instance.broadcasterType,
      'view_count': instance.viewCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
