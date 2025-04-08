import 'package:cloud_firestore/cloud_firestore.dart';


class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String? authorRole;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final List<String> likedBy;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    this.authorRole,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.likedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'authorRole': authorRole,
      'content': content,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'likedBy': likedBy,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorPhotoUrl: json['authorPhotoUrl'],
      authorRole: json['authorRole'],
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls']),
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      likedBy: List<String>.from(json['likedBy']),
    );
  }

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      authorId: data['authorId'],
      authorName: data['authorName'],
      authorPhotoUrl: data['authorPhotoUrl'],
      authorRole: data['authorRole'],
      content: data['content'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorPhotoUrl,
    String? authorRole,
    String? content,
    List<String>? imageUrls,
    DateTime? createdAt,
    List<String>? tags,
    int? likeCount,
    int? commentCount,
    List<String>? likedBy,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
      authorRole: authorRole ?? this.authorRole,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}