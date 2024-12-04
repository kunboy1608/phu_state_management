import 'dart:async';

import 'package:flutter/foundation.dart';

/// A [PhuSphere] is a specialized [Stream] that maintains a state of type [S].
/// It allows emitting new states and listening to state changes.
class PhuSphere<S> extends Stream<S> {
  /// Creates a [PhuSphere] with an initial state.
  ///
  /// The initial state is provided by [_state].
  PhuSphere(this._state) {
    _isClosed = false;
    _controller = StreamController<S>.broadcast();
  }

  late final StreamController<S> _controller;

  /// The current state of the [PhuSphere].
  S get state => _state;
  S _state;

  /// Indicates whether the [PhuSphere] has been closed.
  bool get isClosed => _isClosed;
  late bool _isClosed;

  /// Emits a new state if it is different from the current state and the [PhuSphere] is not closed.
  ///
  /// If the new state is the same as the current state or the [PhuSphere] is closed,
  /// this method does nothing.
  void exude(S state) {
    if (_state == state || isClosed) return;
    _state = state;
    _controller.add(state);
  }

  /// Listens for state changes on the [PhuSphere].
  ///
  /// The [onData] callback is called whenever a new state is emitted.
  /// The [onError], [onDone], and [cancelOnError] parameters are optional and
  /// are passed to the underlying [StreamController]'s listen method.
  @override
  StreamSubscription<S> listen(void Function(S event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  /// Closes the [PhuSphere], preventing any further state emissions.
  ///
  /// This method must be called to release resources when the [PhuSphere] is no longer needed.
  /// After calling this method, the [PhuSphere] is considered closed and no further states can be emitted.
  @mustCallSuper
  void close() {
    debugPrint('$runtimeType closed');
    _isClosed = true;
    _controller.close();
  }
}
