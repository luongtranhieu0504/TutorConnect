

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/domain/repository/conversation_repository.dart';
import 'package:tutorconnect/domain/repository/student_home_repository.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_state.dart';
import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../data/manager/account.dart';
import '../../../domain/model/schedule.dart';
import '../../../domain/model/student.dart';
import '../../../domain/repository/schedule_repository.dart';

@injectable
class ScheduleBloc extends Cubit<ScheduleState> {
  final ScheduleRepository _scheduleRepository;
  final ConversationRepository _conversationRepository;
  final StudentHomeRepository _studentHomeRepository;
  final createScheduleBroadcast =
      StreamWrapper<AsyncState<bool>>(broadcast: true);
  final updateScheduleBroadcast =
      StreamWrapper<AsyncState<void>>(broadcast: true);
  final listenScheduleByIdBroadcast =
      StreamWrapper<AsyncState<Schedule>>(broadcast: true);
  final reminderBroadcast =
      StreamWrapper<AsyncState<void>>(broadcast: true);

  final studentsStream = StreamWrapper<AsyncState<List<Student?>>>(broadcast: true);

  StreamSubscription? _scheduleSubscription;


  ScheduleBloc(this._scheduleRepository, this._conversationRepository, this._studentHomeRepository) : super(ScheduleInitialState());

  void createSchedule(Schedule schedule) async {
    createScheduleBroadcast.add(AsyncState.loading());
    try {
      final result = await _scheduleRepository.addSchedule(schedule);
      result.when(
        success: (createdSchedule) {
          createScheduleBroadcast.add(AsyncState.success(true));
          // fetch data again after create
          getSchedules(studentId: schedule.student.id, tutorId: schedule.tutor.id);
        },
        failure: (error) {
          createScheduleBroadcast.add(AsyncState.failure(error));
        },
      );
    } catch (e) {
      createScheduleBroadcast.add(AsyncState.failure(e.toString()));
    }
  }

  void fetchStudentsWithConversations() async {
    try {
      studentsStream.add(AsyncState.loading());
      final result = await _conversationRepository.getConversations(tutorId: Account.instance.tutor?.id);
      result.when(
        success: (conversations) async {
          final studentIds = conversations.map((c) => c.otherUser?.id).whereType<int>().toList();
          List<Student> studentsList = [];
          for (final id in studentIds) {
            final studentResult = await _studentHomeRepository.getStudentById(id);
            studentResult.when(
              success: (student) => studentsList.add(student!),
              failure: (_) {}, // Có thể log lỗi nếu muốn
            );
          }
          studentsStream.add(AsyncState.success(studentsList));
        },
        failure: (error) {
          studentsStream.add(AsyncState.failure(error));
        },
      );
    } catch (e) {
      studentsStream.add(AsyncState.failure(e.toString()));
    }
  }

  void getSchedules({int? studentId, int? tutorId}) async {
    emit(ScheduleLoadingState());
    final schedules = await _scheduleRepository.getSchedules(studentId: studentId, tutorId: tutorId);
    schedules.when(
      success: (schedules) {
        emit(ScheduleSuccessState(schedules));
      },
      failure: (message) {
        emit(ScheduleFailureState(message));
      },
    );
  }



  void updateSchedule(int scheduleId, Schedule schedule) async {
    updateScheduleBroadcast.add(AsyncState.loading());
    try {
      final result = await _scheduleRepository.updateSchedule(scheduleId, schedule);
      result.when(
        success: (_) {
          updateScheduleBroadcast.add(AsyncState.success(null));
          // fetch data again after update
          getSchedules(studentId: schedule.student.id, tutorId: schedule.tutor.id);
        },
        failure: (error) {
          updateScheduleBroadcast.add(AsyncState.failure(error));
        },
      );
    } catch (e) {
      updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
    }
  }


  void deleteSchedule(int scheduleId) async {
    updateScheduleBroadcast.add(AsyncState.loading());
    try {
      final result = await _scheduleRepository.deleteSchedule(scheduleId);
      result.when(
        success: (_) => updateScheduleBroadcast.add(AsyncState.success(null)),
        failure: (message) => updateScheduleBroadcast.add(AsyncState.failure(message)),
      );
    } catch (e) {
      updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
    }
  }


void getApprovedSchedulesByDate(DateTime date) async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
  final result = await _scheduleRepository.getSchedules(
    tutorId: Account.instance.tutor?.id,
    studentId: Account.instance.student?.id,
  );
  result.when(
    success: (schedules) {
      final filteredSchedules = schedules.where((s) =>
          s.status == 'approved' &&
          DateFormat('yyyy-MM-dd').format(s.startDate!) == formattedDate).toList();
      emit(ScheduleSuccessState(filteredSchedules));
    },
    failure: (error) {
      emit(ScheduleFailureState(error));
    },
  );
}


  @override
  Future<void> close() {
    _scheduleSubscription?.cancel();
    return super.close();
  }


}