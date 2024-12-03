import 'dart:async';

import 'package:flutter/widgets.dart';

import 'build_context_ext.dart';
import 'phu_sphere.dart';

typedef BuildWhen<S> = bool Function(S previous, S current);
typedef SphereWidgetBuilder<S> = Widget Function(BuildContext context, S state);
typedef SphereBuildCallback<S> = void Function(BuildContext context, S state);

class PhuStateBuilder<P extends PhuSphere<S>, S> extends StatefulWidget {
  const PhuStateBuilder({
    super.key,
    this.sphere,
    this.buildWhen,
    required this.builder,
  });

  final P? sphere;
  final BuildWhen<S>? buildWhen;
  final SphereWidgetBuilder<S> builder;

  @override
  State<StatefulWidget> createState() => _PhuStateBuilderState<P, S>();
}

class _PhuStateBuilderState<P extends PhuSphere<S>, S>
    extends State<PhuStateBuilder<P, S>> {
  late P _sphere;
  late S _state;

  @override
  void initState() {
    super.initState();
    _sphere = widget.sphere ?? context.read<P>();
    _state = _sphere.state;
  }

  @override
  void didUpdateWidget(PhuStateBuilder<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldSphere = oldWidget.sphere ?? context.read<P>();
    final currentSphere = widget.sphere ?? oldSphere;
    if (oldSphere != currentSphere) {
      _sphere = currentSphere;
      _state = _sphere.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sphere = widget.sphere ?? context.read<P>();
    if (_sphere != sphere) {
      _sphere = sphere;
      _state = _sphere.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PhuSphereListener(
      sphere: _sphere,
      buildWhen: widget.buildWhen,
      buildCallBack: (context, S state) => setState(() => _state = state),
      child: widget.builder(context, _state),
    );
  }
}

class _PhuSphereListener<P extends PhuSphere<S>, S> extends StatefulWidget {
  const _PhuSphereListener({
    super.key,
    required this.sphere,
    this.buildWhen,
    required this.child,
    required this.buildCallBack,
  });

  final P sphere;
  final BuildWhen<S>? buildWhen;
  final SphereBuildCallback<S> buildCallBack;
  final Widget child;

  @override
  State<_PhuSphereListener> createState() => _PhuSphereListenerState<P, S>();
}

class _PhuSphereListenerState<P extends PhuSphere<S>, S>
    extends State<_PhuSphereListener<P, S>> {
  StreamSubscription<S>? _subscription;
  late P _sphere;
  late S _previousState;

  @override
  void initState() {
    super.initState();
    _sphere = widget.sphere;
    _previousState = _sphere.state;
    _subscribe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentSphere = widget.sphere;
    if (_sphere != currentSphere) {
      _unsubscribe();
      _sphere = currentSphere;
      _previousState = _sphere.state;
      _subscribe();
    }
  }

  @override
  void didUpdateWidget(covariant _PhuSphereListener<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sphere != oldWidget.sphere) {
      _unsubscribe();
      _sphere = widget.sphere;
      _previousState = _sphere.state;
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _sphere.listen((state) {
      if (!mounted) return;
      if (widget.buildWhen?.call(_previousState, state) ?? true) {
        widget.buildCallBack(context, state);
      }
      _previousState = state;
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
