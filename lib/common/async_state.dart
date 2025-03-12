class AsyncState<T> {
  final T? data;
  final String? message;
  final bool isLoading;

  const AsyncState._({this.data, this.message, this.isLoading = false});

  const AsyncState.loading() : this._(isLoading: true);
  const AsyncState.success(T data) : this._(data: data);
  const AsyncState.failure(String message) : this._(message: message);

  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    if (isLoading) {
      return loading();
    } else if (data != null) {
      return success(data as T);
    } else {
      return failure(message ?? "Lỗi không xác định");
    }
  }
}
