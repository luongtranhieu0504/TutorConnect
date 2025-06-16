

import '../../../domain/model/user.dart';

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final User user;

  ProfileSuccess(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}