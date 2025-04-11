import '../../../../data/models/users.dart';

abstract class StudentHomeState {}

class UserInitial extends StudentHomeState {}

class UserLoading extends StudentHomeState {}

class UserSuccess extends StudentHomeState {
  final UserModel user;
  UserSuccess(this.user);
}

class UserFailure extends StudentHomeState {
  final String message;
  UserFailure(this.message);
}
