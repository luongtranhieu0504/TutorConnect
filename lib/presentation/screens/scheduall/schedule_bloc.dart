//
//
// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:tutorconnect/domain/models/schedule_model.dart';
// import 'package:tutorconnect/domain/repository/chat_repositpry.dart';
// import 'package:tutorconnect/presentation/screens/scheduall/schedule_state.dart';
// import '../../../common/async_state.dart';
// import '../../../common/stream_wrapper.dart';
// import '../../../domain/models/chat_model.dart';
// import '../../../domain/repository/schedule_repository.dart';
// import '../chat/chat_state.dart';
//
// @injectable
// class ScheduleBloc extends Cubit<ScheduleState> {
//   final ScheduleRepository _scheduleRepository;
//   final ChatRepository _chatRepository;
//   final createOrGetScheduleBroadcast =
//       StreamWrapper<AsyncState<String>>(broadcast: true);
//   final updateScheduleBroadcast =
//       StreamWrapper<AsyncState<void>>(broadcast: true);
//   final sendChatBroadcast =
//       StreamWrapper<AsyncState<void>>(broadcast: true);
//   final listenScheduleByIdBroadcast =
//       StreamWrapper<AsyncState<ScheduleModel>>(broadcast: true);
//   final reminderBroadcast =
//       StreamWrapper<AsyncState<void>>(broadcast: true);
//   StreamSubscription? _scheduleSubscription;
//
//
//   ScheduleBloc(this._scheduleRepository, this._chatRepository) : super(ScheduleInitialState());
//
//   void createOrGetSchedule(String userId, String scheduleId) async {
//     createOrGetScheduleBroadcast.add(AsyncState.loading());
//     try {
//       final result = await _scheduleRepository.createOrGetSchedule(
//         userId: userId,
//         scheduleId: scheduleId,
//       );
//       result.when(
//         success: (scheduleId) {
//           createOrGetScheduleBroadcast.add(AsyncState.success(scheduleId));
//         },
//         failure: (message) {
//           createOrGetScheduleBroadcast.add(AsyncState.failure(message));
//         },
//       );
//     } catch (e) {
//       createOrGetScheduleBroadcast.add(AsyncState.failure(e.toString()));
//     }
//   }
//
//   void listenSchedule(String userId, {required String role}) async {
//     emit(ScheduleLoadingState());
//     _scheduleSubscription?.cancel();
//     _scheduleRepository.listenSchedule(userId, role: role).listen((result) {
//       result.when(
//         success: (schedules) {
//           emit(ScheduleSuccessState(schedules));
//         },
//         failure: (error) => emit(ScheduleFailureState(error)),
//       );
//     });
//   }
//
//
//
//   void sendSchedule(String userId, ScheduleModel schedule) async {
//     sendChatBroadcast.add(AsyncState.loading());
//     final result = await _scheduleRepository.sendSchedule(userId, schedule);
//     result.when(
//       success: (_) => sendChatBroadcast.add(AsyncState.success(null)),
//       failure: (error) => sendChatBroadcast.add(AsyncState.failure(error)),
//     );
//   }
//
//   void updateScheduleAndNotify(String scheduleId, ScheduleModel schedule) async {
//     sendChatBroadcast.add(AsyncState.loading());
//     try {
//       // First update the schedule
//       final scheduleResult = await _scheduleRepository.updateSchedule(
//         scheduleId,
//         schedule,
//       );
//       if (scheduleResult.isSuccess) {
//         // Get or create conversation between tutor and student
//         final chatResult = await _chatRepository.createOrGetConversation(
//           userId1: schedule.tutorId,
//           userId2: schedule.studentId,
//         );
//         if (chatResult.isSuccess) {
//           final conversationId = chatResult.data;
//           final message = ChatModel(
//             id: '',
//             senderId: schedule.tutorId,
//             receiverId: schedule.studentId,
//             content: 'Lịch học mới đã được tạo: ${schedule.topic}',
//             type: 'schedule',
//             timestamp: DateTime.now(),
//             isRead: false,
//             scheduleId: scheduleId,
//           );
//
//           // Send the chat message
//           final sendResult = await _chatRepository.sendChat(conversationId!, message);
//           if (sendResult.isSuccess) {
//             // Explicitly emit success state
//             sendChatBroadcast.add(AsyncState.success(null));
//           } else {
//             sendChatBroadcast.add(AsyncState.failure(sendResult.message!));
//           }
//         }
//       } else {
//         scheduleResult.when(
//           success: (_) {},
//           failure: (message) {
//             updateScheduleBroadcast.add(AsyncState.failure(message));
//           },
//         );
//       }
//     } catch (e) {
//       updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
//     }
//   }
//
//   void updateScheduleStatus(String scheduleId, String status) async {
//     updateScheduleBroadcast.add(AsyncState.loading());
//     try {
//       final result = await _scheduleRepository.getScheduleById(scheduleId);
//       result.when(
//         success: (schedule) => _scheduleRepository.updateScheduleStatus(
//           scheduleId,
//           {'status': status},
//         ).then((schedule) {
//           updateScheduleBroadcast.add(AsyncState.success(null));
//         }),
//         failure: (message) => updateScheduleBroadcast.add(AsyncState.failure(message)),
//       );
//     } catch (e) {
//       updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
//     }
//   }
//
//   void approveSchedule(String scheduleId) async {
//     updateScheduleBroadcast.add(AsyncState.loading());
//     try {
//       final result = await _scheduleRepository.getScheduleById(scheduleId);
//       result.when(
//         success: (schedule) async {
//           final updateResult = await _scheduleRepository.updateScheduleStatus(
//             scheduleId,
//             {'status': 'approved'},
//           );
//           updateResult.when(
//             success: (_) async {
//               // Now schedule the reminders
//               final reminderResult = await _scheduleRepository.scheduleReminder(schedule);
//               reminderResult.when(
//                 success: (_) => updateScheduleBroadcast.add(AsyncState.success(null)),
//                 failure: (error) => updateScheduleBroadcast.add(AsyncState.failure(error)),
//               );
//             },
//             failure: (error) => updateScheduleBroadcast.add(AsyncState.failure(error)),
//           );
//         },
//         failure: (error) => updateScheduleBroadcast.add(AsyncState.failure(error)),
//       );
//     } catch (e) {
//       updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
//     }
//   }
//
//
//   void deleteSchedule(String scheduleId) async {
//     updateScheduleBroadcast.add(AsyncState.loading());
//     try {
//       final result = await _scheduleRepository.deleteSchedule(scheduleId);
//       result.when(
//         success: (_) => updateScheduleBroadcast.add(AsyncState.success(null)),
//         failure: (message) => updateScheduleBroadcast.add(AsyncState.failure(message)),
//       );
//     } catch (e) {
//       updateScheduleBroadcast.add(AsyncState.failure(e.toString()));
//     }
//   }
//
//
//
//   void cancelReminder(String scheduleId) async {
//     reminderBroadcast.add(AsyncState.loading());
//     try {
//       final result = await _scheduleRepository.cancelReminder(scheduleId);
//       result.when(
//         success: (_) => reminderBroadcast.add(AsyncState.success(null)),
//         failure: (error) => reminderBroadcast.add(AsyncState.failure(error)),
//       );
//     } catch (e) {
//       reminderBroadcast.add(AsyncState.failure(e.toString()));
//     }
//   }
//
//
//
// }