
import '../../../../domain/model/tutor.dart';

abstract class FavoriteState {}

class Initial extends FavoriteState {}

class Loading extends FavoriteState {}


class Success extends FavoriteState {
  final List<Tutor> favoriteTutors;
  Success(this.favoriteTutors);
}

class Failure extends FavoriteState {
  final String message;
  Failure(this.message);
}
