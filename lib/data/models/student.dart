import 'package:tutorconnect/data/models/comment.dart';
import 'package:tutorconnect/data/models/post.dart';
import 'package:tutorconnect/data/models/session.dart';

class StudentProfile {
  final List<String> favorites;
  final List<SessionModel> learningHistory;
  final List<Post> posts;
  final List<Comment> comments;

  StudentProfile(this.posts, this.comments,
    this.favorites,
    this.learningHistory,
  );

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      (json['posts'] as List?)
          ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      (json['comments'] as List?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      (json['favorites'] as List?)?.map((e) => e.toString()).toList() ?? [],
      (json['learning_history'] as List?)
          ?.map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorites': favorites,
      'learningHistory': learningHistory.map((e) => e.toJson()).toList(),
      'posts': posts.map((e) => e.toJson()).toList(),
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }


  StudentProfile copyWith({
    List<String>? favorites,
    List<SessionModel>? learningHistory,
    List<Post>? posts,
    List<Comment>? comments,
  }) {
    return StudentProfile(
      posts ?? this.posts,
      comments ?? this.comments,
      favorites ?? this.favorites,
      learningHistory ?? this.learningHistory,
    );
  }

}




