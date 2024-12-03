import 'dart:async';

class PhuSphere<S> extends Stream<S> {
  PhuSphere(this.state);
  final StreamController<S> _controller = StreamController<S>.broadcast();
  final S state;

  @override
  StreamSubscription<S> listen(void Function(S event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
