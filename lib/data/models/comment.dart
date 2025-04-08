import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String? authorRole;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    this.authorRole,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'authorRole': authorRole,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorPhotoUrl: json['authorPhotoUrl'],
      authorRole: json['authorRole'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      postId: data['postId'],
      authorId: data['authorId'],
      authorName: data['authorName'],
      authorPhotoUrl: data['authorPhotoUrl'],
      authorRole: data['authorRole'],
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}