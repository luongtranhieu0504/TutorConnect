abstract class AsyncState<T> {
  const AsyncState();
}

class InitialState<T> extends AsyncState<T> {}

class LoadingState<T> extends AsyncState<T> {}

class SuccessState<T> extends AsyncState<T> {
  final T data;
  const SuccessState(this.data);
}

class ErrorState<T> extends AsyncState<T> {
  final String message;
  const ErrorState(this.message);
}
