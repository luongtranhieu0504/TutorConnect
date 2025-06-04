// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:tutorconnect/common/stream_wrapper.dart';
// import 'package:tutorconnect/domain/repository/schedule_repository.dart';
// import 'package:tutorconnect/domain/services/notification_service.dart';
// import '../../../common/async_state.dart';
// import '../../../common/task_result.dart';
// import '../../../data/manager/account.dart';
// import '../../../domain/models/chat_model.dart';
// import '../../../domain/models/schedule_model.dart';
// import '../../../domain/repository/chat_repositpry.dart';
// import 'chat_state.dart';
//
// @injectable
// class ChatBloc extends Cubit<ChatState> {
//   final ChatRepository _chatRepository;
//   final ScheduleRepository _scheduleRepository;
//   final sendChatBroadcast = StreamWrapper<AsyncState<void>>(broadcast: true);
//   final createOrGetScheduleBroadcast =
//       StreamWrapper<AsyncState<String>>(broadcast: true);
//   final getScheduleByIdBroadcast =
//       StreamWrapper<AsyncState<ScheduleModel>>(broadcast: true);
//   StreamSubscription<TaskResult<ScheduleModel>>? _scheduleSub;
//
//   StreamSubscription? _chatSubscription;
//
//   ChatBloc(this._chatRepository, this._scheduleRepository)
//       : super(ChatInitial());
//
//   void listenChat(String conversationId) async {
//     emit(ChatLoading());
//
//     _chatSubscription?.cancel();
//     _chatRepository.listenChat(conversationId).listen((result) {
//       result.when(
//         success: (chats) {
//           // Find schedule messages safely
//           final scheduleMessages = chats
//               .where(
//                   (chat) => chat.type == 'schedule' && chat.scheduleId != null)
//               .toList();
//
//           if (scheduleMessages.isNotEmpty) {
//             _getScheduleById(
//                 chats, conversationId, scheduleMessages.first.scheduleId!);
//           } else {
//             // No schedule to load
//             emit(ChatSuccess(chats, conversationId, null));
//           }
//         },
//         failure: (error) => emit(ChatFailure(error)),
//       );
//     });
//   }
//
//   void createOrGetConversation(String userId1, String userId2) async {
//     emit(ChatLoading());
//     final result = await _chatRepository.createOrGetConversation(
//         userId1: userId1, userId2: userId2);
//     result.when(
//       success: (conversationId) => listenChat(conversationId),
//       failure: (error) => emit(ChatFailure(error)),
//     );
//   }
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
//   void sendChat(String conversationId, ChatModel chat) async {
//     sendChatBroadcast.add(AsyncState.loading());
//     final result = await _chatRepository.sendChat(conversationId, chat);
//     final senderName = Account.instance.user.name;
//     await NotificationService().sendChatNotificationFromClient(
//         receiverId: chat.receiverId,
//         senderId: chat.senderId,
//         conversationId: conversationId,
//         content: chat.content,
//         senderName: senderName!,
//         type: chat.type);
//     result.when(
//       success: (_) => sendChatBroadcast.add(AsyncState.success(null)),
//       failure: (error) => sendChatBroadcast.add(AsyncState.failure(error)),
//     );
//   }
//
//   void _getScheduleById(
//       List<ChatModel> chats, String conversationId, String scheduleId) async {
//     emit(ChatLoading());
//     final result = await _scheduleRepository.getScheduleById(scheduleId);
//     result.when(
//       success: (schedule) => emit(ChatSuccess(chats, conversationId, schedule)),
//       failure: (error) =>
//           getScheduleByIdBroadcast.add(AsyncState.failure(error)),
//     );
//   }
//
//   void deleteConversation(String conversationId) async {
//     emit(ChatLoading());
//     final result = await _chatRepository.deleteConversation(conversationId);
//     result.when(
//       success: (_) => emit(ChatInitial()),
//       failure: (error) => emit(ChatFailure(error)),
//     );
//   }
//
//   @override
//   Future<void> close() {
//     _chatSubscription?.cancel();
//     _scheduleSub?.cancel();
//     return super.close();
//   }
// }
