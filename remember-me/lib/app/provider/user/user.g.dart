// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firebase_uid: json['firebase_uid'] as String,
  display_name: json['display_name'] as String,
  created_at: json['created_at'] as String,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firebase_uid': instance.firebase_uid,
      'display_name': instance.display_name,
      'created_at': instance.created_at,
    };
