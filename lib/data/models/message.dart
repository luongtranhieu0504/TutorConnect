class MessageModel {
  final String name;
  final String subject;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isUnread;
  final bool isOnline;

  MessageModel({
    required this.name,
    required this.subject,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.isUnread = false,
    this.isOnline = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "subject": subject,
      "message": message,
      "time": time,
      "avatarUrl": avatarUrl,
      "isUnread": isUnread,
      "isOnline": isOnline,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      name: json["name"],
      subject: json["subject"],
      message: json["message"],
      time: json["time"],
      avatarUrl: json["avatarUrl"],
      isUnread: json["isUnread"],
      isOnline: json["isOnline"],
    );
  }
}