import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/data/models/users.dart';

class ConversationWithUser {
  final ConversationModel conversation;
  final UserModel otherUser;

  ConversationWithUser({
    required this.conversation,
    required this.otherUser,
  });
}



class ConversationModel {
  final String id;
  final List<String> participants; // [studentId, tutorId]
  final String? lastMessage;
  final Timestamp? lastTimestamp;
  final Timestamp? createdAt;

  ConversationModel({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastTimestamp,
    this.createdAt,
  });

  ConversationModel copyWith({
      String? id,
      List<String>? participants,
      String? lastMessage,
      Timestamp? lastTimestamp,
      Timestamp? createdAt,
    }) {
      return ConversationModel(
        id: id ?? this.id,
        participants: participants ?? this.participants,
        lastMessage: lastMessage ?? this.lastMessage,
        lastTimestamp: lastTimestamp ?? this.lastTimestamp,
        createdAt: createdAt ?? this.createdAt,
      );
    }

  factory ConversationModel.fromJson(String id, Map<String, dynamic> json) {
    return ConversationModel(
      id: id,
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'],
      lastTimestamp: json['lastTimestamp'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp ?? FieldValue.serverTimestamp(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
