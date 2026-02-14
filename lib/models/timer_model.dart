import 'package:json_annotation/json_annotation.dart';

part 'timer_model.g.dart';

enum TimerStatus { idle, running, paused, completed }

@JsonSerializable()
class TimerModel {
  final String id;
  final String label;
  final Duration duration;
  final Duration remainingTime;
  final TimerStatus status;
  final String? command;
  final String? soundFile;

  TimerModel({
    required this.id,
    required this.label,
    required this.duration,
    required this.remainingTime,
    this.status = TimerStatus.idle,
    this.command,
    this.soundFile,
  });

  TimerModel copyWith({
    String? id,
    String? label,
    Duration? duration,
    Duration? remainingTime,
    TimerStatus? status,
    String? command,
    String? soundFile,
  }) {
    return TimerModel(
      id: id ?? this.id,
      label: label ?? this.label,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      command: command ?? this.command,
      soundFile: soundFile ?? this.soundFile,
    );
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) =>
      _$TimerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimerModelToJson(this);
}
