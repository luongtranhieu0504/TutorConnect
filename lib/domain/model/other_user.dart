

import 'package:freezed_annotation/freezed_annotation.dart';

part 'other_user.freezed.dart';
part 'other_user.g.dart';

@freezed
class OtherUser with _$OtherUser {
  const factory OtherUser({
    required int id,
    String? name,
    String? email,
    String? photoUrl,
    String? address,
  }) = _OtherUser;

  factory OtherUser.fromJson(Map<String, dynamic> json) =>
      _$OtherUserFromJson(json);
}