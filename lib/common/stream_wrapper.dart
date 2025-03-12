import 'dart:async';

class StreamWrapper<T> {
  late final StreamController<T> _streamController;

  Sink<T> get _sink => _streamController.sink;

  Stream<T> get _stream => _streamController.stream;

  StreamWrapper({bool broadcast = false}) {
    if (broadcast) {
      _streamController = StreamController<T>.broadcast();
    } else {
      _streamController = StreamController<T>();
    }
  }

  void add(T data) {
    _sink.add(data);
  }

  StreamSubscription<T> listen(
     void Function(T event)? onData, {
     Function? onError,
     void Function()? onDone,
     bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void close() {
    _streamController.close();
  }
}