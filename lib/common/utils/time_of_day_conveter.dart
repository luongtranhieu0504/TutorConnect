import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay?, Map<String, int?>?> {
  const TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(Map<String, int?>? json) {
    if (json == null) return null;
    return TimeOfDay(hour: json['hour'] ?? 0, minute: json['minute'] ?? 0);
  }

  @override
  Map<String, int?>? toJson(TimeOfDay? time) {
    if (time == null) return null;
    return {
      'hour': time.hour,
      'minute': time.minute,
    };
  }
}