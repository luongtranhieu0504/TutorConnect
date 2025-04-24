
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/data/models/users.dart';

import '../../domain/repository/message_repository.dart';
import '../models/coversation.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepositoryImpl(this._firestore);
  final user = Account.instance.user;

  @override
  Future<List<ConversationWithUser>> getConversations() async {
    try {
      final querySnapshot = await _firestore
          .collection('conversations')
          .where('participants', arrayContains: user.uid)
          .orderBy('lastTimestamp', descending: true)
          .get();

      final List<ConversationWithUser> result = [];

      for (var doc in querySnapshot.docs) {
        final conversation = ConversationModel.fromJson(doc.id, doc.data());
        final otherUserId = conversation.participants.firstWhere((id) => id != user.uid);

        final otherUserDoc = await _firestore.collection('users').doc(otherUserId).get();
        if (otherUserDoc.exists) {
          final otherUser = UserModel.fromJson({...otherUserDoc.data()!, "uid": otherUserDoc.id});
          result.add(ConversationWithUser(
            conversation: conversation,
            otherUser: otherUser,
          ));
        }
      }

      return result;
    } catch (e) {
      throw Exception("Error fetching conversations: $e");
    }
  }

  @override
  Future<void> deleteMessage(String conversationId) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).delete();
    } catch (e) {
      throw Exception("Error deleting message: $e");
    }
  }

  @override
  Future<void> updateMessage(String messageId, String newContent) async {
    try {
      await _firestore.collection('messages').doc(messageId).update({
        'content': newContent,
      });
    } catch (e) {
      throw Exception("Error updating message: $e");
    }
  }
}