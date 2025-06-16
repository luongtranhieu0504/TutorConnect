
import '../../../domain/model/schedule.dart';

abstract class ScheduleState {}
class ScheduleInitialState extends ScheduleState {}

class ScheduleLoadingState extends ScheduleState {}

class ScheduleSuccessState extends ScheduleState {
  final List<Schedule> schedules;

  ScheduleSuccessState(this.schedules,);
}

class ScheduleFailureState extends ScheduleState {
  final String error;

  ScheduleFailureState(
    this.error,
  );
}