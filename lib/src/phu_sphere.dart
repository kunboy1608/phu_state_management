import 'dart:async';

import 'package:flutter/widgets.dart';

class PhuSphere<S> extends Stream<S> {
  PhuSphere(this._state) {
    _isClosed = false;
  }

  final StreamController<S> _controller = StreamController<S>.broadcast();

  S get state => _state;
  S _state;

  bool get isClosed => _isClosed;
  late bool _isClosed;

  void exude(S state) {
    if (_state == state || isClosed) return;
    _state = state;
    _controller.add(state);
  }

  @override
  StreamSubscription<S> listen(void Function(S event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @mustCallSuper
  void close() {
    debugPrint('$runtimeType closed');
    _isClosed = true;
    _controller.close();
  }
}
