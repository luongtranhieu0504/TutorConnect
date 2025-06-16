

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/domain/model/other_user.dart';
import 'package:tutorconnect/domain/repository/conversation_repository.dart';
import 'package:tutorconnect/domain/repository/student_home_repository.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_state.dart';
import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../data/manager/account.dart';
import '../../../domain/model/schedule.dart';
import '../../../domain/model/student.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/schedule_repository.dart';
import '../chat/chat_state.dart';

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


  // void updateScheduleAndNotify(String scheduleId, Schedule schedule) async {
  //   sendChatBroadcast.add(AsyncState.loading());
  //   try {
  //     // First update the schedule
  //     final scheduleResult = await _scheduleRepository.updateSchedule(
  //       scheduleId,
  //       schedule,
  //     );
  //     if (scheduleResult.isSuccess) {
  //       // Get or create conversation between tutor and student
  //       final chatResult = await _chatRepository.createOrGetConversation(
  //         userId1: schedule.tutorId,
  //         userId2: schedule.studentId,
  //       );
  //       if (chatResult.isSuccess) {
  //         final conversationId = chatResult.data;
  //         final message = ChatModel(
  //           id: '',
  //           senderId: schedule.tutorId,
  //           receiverId: schedule.studentId,
  //           content: 'Lịch học mới đã được tạo: ${schedule.topic}',
  //           type: 'schedule',
  //           timestamp: DateTime.now(),
  //           isRead: false,
  //           scheduleId: scheduleId,
  //         );
  //
  //         // Send the chat message
  //         final sendResult = await _chatRepository.sendChat(conversationId!, message);
  //         if (sendResult.isSuccess) {
  //           // Explicitly emit success state
  //           sendChatBroadcast.add(AsyncState.success(null));
  //         } else {
  //           sendChatBroadcast.add(AsyncState.failure(sendResult.message!));
  //         }
  //       }
  //     } else {
  //       scheduleResult.when(
  //         success: (_) {},
  //         failure: (message) {
  //           updateScheduleBroadcast.add(AsyncState.failure(message));
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
  //   }
  // }


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



  // void cancelReminder(String scheduleId) async {
  //   reminderBroadcast.add(AsyncState.loading());
  //   try {
  //     final result = await _scheduleRepository.cancelReminder(scheduleId);
  //     result.when(
  //       success: (_) => reminderBroadcast.add(AsyncState.success(null)),
  //       failure: (error) => reminderBroadcast.add(AsyncState.failure(error)),
  //     );
  //   } catch (e) {
  //     reminderBroadcast.add(AsyncState.failure(e.toString()));
  //   }
  // }
  @override
  Future<void> close() {
    _scheduleSubscription?.cancel();
    return super.close();
  }


}