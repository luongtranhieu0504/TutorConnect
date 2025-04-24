class ChatModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String type; // text, image, video, audio, file
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? videoUrl;
  final String? fileUrl;
  final Map<String, String>? reactions; // userId: emojiCode

  ChatModel({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.imageUrl,
    this.videoUrl,
    this.fileUrl,
    this.reactions,
  });

  ChatModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    String? imageUrl,
    String? videoUrl,
    String? fileUrl,
    Map<String, String>? reactions,
  }) {
    return ChatModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      reactions: reactions ?? this.reactions,
    );
  }

  factory ChatModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatModel(
      id: id,
      receiverId: json['receiver_id'],
      senderId: json['sender_id'],
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'])
          : (json['timestamp'] as dynamic).toDate(),
      isRead: json['is_read'] ?? false,
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      fileUrl: json['file_url'],
      reactions: json['reactions'] != null
          ? Map<String, String>.from(json['reactions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'sender_id': senderId,
    'receiver_id': receiverId,
    'content': content,
    'type': type,
    'timestamp': timestamp.toIso8601String(),
    'is_read': isRead,
    if (imageUrl != null) 'image_url': imageUrl,
    if (videoUrl != null) 'video_url': videoUrl,
    if (fileUrl != null) 'file_url': fileUrl,
    if (reactions != null) 'reactions': reactions,
  };

}

