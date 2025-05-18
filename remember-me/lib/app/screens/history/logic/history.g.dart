// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryImpl _$$HistoryImplFromJson(Map<String, dynamic> json) =>
    _$HistoryImpl(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String? ?? "",
      image_url: json['image_url'] as String? ?? "",
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$HistoryImplToJson(_$HistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'image_url': instance.image_url,
      'created_at': instance.created_at.toIso8601String(),
    };
