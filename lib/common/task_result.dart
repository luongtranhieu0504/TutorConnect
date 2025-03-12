class TaskResult<T> {
  final T? data;
  final String? message;
  final bool isSuccess;

  TaskResult.success(this.data) : isSuccess = true, message = null;
  TaskResult.failure(this.message) : isSuccess = false, data = null;

  void when({
    required void Function(T data) success,
    required void Function(String message) failure,
  }) {
    if (isSuccess && data != null) {
      success(data as T);
    } else {
      failure(message ?? "Lỗi không xác định");
    }
  }
}


