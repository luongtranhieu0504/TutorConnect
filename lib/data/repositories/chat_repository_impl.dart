
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../common/task_result.dart';
import '../../domain/repository/chat_repositpry.dart';
import '../models/chat.dart';
import '../models/coversation.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  
  ChatRepositoryImpl(this._firestore);

  @override
  Future<TaskResult<String>> createOrGetConversation({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final List<String> participants = [userId1, userId2]..sort();

      // 🔍 Tìm xem đã có conversation giữa 2 người này chưa
      final existingConversations = await _firestore
          .collection('conversations')
          .where('participants', isEqualTo: participants)
          .limit(1)
          .get();

      if (existingConversations.docs.isNotEmpty) {
        final conversationId = existingConversations.docs.first.id;
        return TaskResult.success(conversationId);
      }

      // 🆕 Nếu chưa có → tạo mới với Firestore tự sinh ID
      final newConversation = ConversationModel(
        id: '', // sẽ được cập nhật lại sau
        participants: participants,
        lastMessage: null,
        lastTimestamp: null,
        createdAt: Timestamp.now(),
      );

      final docRef = await _firestore
          .collection('conversations')
          .add(newConversation.toJson());

      // Optionally update conversation.id field (nếu bạn cần lưu ID vào chính doc đó)
      await docRef.update({'id': docRef.id});

      return TaskResult.success(docRef.id);
    } catch (e) {
      return TaskResult.failure("Error creating or getting conversation: $e");
    }
  }

  @override
  Stream<TaskResult<List<ChatModel>>> listenChat(String conversationId) {
    try {
      return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          final chats = snapshot.docs.map((doc) {
            return ChatModel.fromJson(doc.id,doc.data());
          }).toList();

          return TaskResult.success(chats);
        })
        .handleError((e) =>
          Stream.value(TaskResult.failure("Error fetching chat messages: $e")));
    } catch (e) {
      return Stream.value(TaskResult.failure("Error listening to chat: $e"));
    }
  }

  @override
  Future<TaskResult<void>> sendChat(String conversationId, ChatModel chat) async {
    try {
      final docRef = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc();

      final chatWithId = chat.copyWith(id: docRef.id);

      await docRef.set(chatWithId.toJson());

      // Update the last message and timestamp in the message
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': chat.content,
        'lastTimestamp': FieldValue.serverTimestamp(),
      });

      return TaskResult.success(null);
    } catch (e) {
      return TaskResult.failure("Error sending chat message: $e");
    }
  }

  @override
  Future<TaskResult<void>> deleteConversation(String conversationId) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).delete();
      return TaskResult.success(null);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }
}