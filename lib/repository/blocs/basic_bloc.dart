import 'dart:async';

abstract class BasicBloc<T> {
  final StreamController _basicStream = StreamController<T>.broadcast();

  Stream<T> get stream => _basicStream.stream as Stream<T>;

  void add(T data) {
    _basicStream.sink.add(data);
  }

  void addError(dynamic error) {
    _basicStream.sink.addError(error);
  }

  void dispose() {
    _basicStream.close();
  }

  T resultError(T error) {
    add(error);
    return error;
  }

  T resultSuccess(T data) {
    add(data);
    return data;
  }
}
