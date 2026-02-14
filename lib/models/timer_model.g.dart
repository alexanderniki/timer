// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimerModel _$TimerModelFromJson(Map<String, dynamic> json) => TimerModel(
  id: json['id'] as String,
  label: json['label'] as String,
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  remainingTime: Duration(microseconds: (json['remainingTime'] as num).toInt()),
  status:
      $enumDecodeNullable(_$TimerStatusEnumMap, json['status']) ??
      TimerStatus.idle,
  command: json['command'] as String?,
  soundFile: json['soundFile'] as String?,
);

Map<String, dynamic> _$TimerModelToJson(TimerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'duration': instance.duration.inMicroseconds,
      'remainingTime': instance.remainingTime.inMicroseconds,
      'status': _$TimerStatusEnumMap[instance.status]!,
      'command': instance.command,
      'soundFile': instance.soundFile,
    };

const _$TimerStatusEnumMap = {
  TimerStatus.idle: 'idle',
  TimerStatus.running: 'running',
  TimerStatus.paused: 'paused',
  TimerStatus.completed: 'completed',
};
