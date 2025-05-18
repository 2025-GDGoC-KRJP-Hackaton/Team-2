// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryStateImpl _$$HistoryStateImplFromJson(Map<String, dynamic> json) =>
    _$HistoryStateImpl(
      histories:
          (json['histories'] as List<dynamic>?)
              ?.map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$HistoryStateImplToJson(_$HistoryStateImpl instance) =>
    <String, dynamic>{'histories': instance.histories};
