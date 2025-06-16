import '../../domain/model/other_user.dart';
import '../network/dto/other_user_dto.dart';

extension OtherUserDtoExt on OtherUserDto {
  OtherUser toModel() => OtherUser(
    id: id,
    name: name,
    email: email,
    photoUrl: photoUrl,
  );
}