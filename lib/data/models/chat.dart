class ChatModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String type; // text, image, file
  final DateTime timestamp;
  final bool isRead;

  ChatModel({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      receiverId: json['receiver_id'],
      senderId: json['sender_id'],
      content: json['content'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'receiver_id': receiverId,
    'sender_id': senderId,
    'content': content,
    'type': type,
    'timestamp': timestamp.toIso8601String(),
    'is_read': isRead,
  };
}
