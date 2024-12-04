import 'dart:async';

import 'package:flutter/widgets.dart';

import 'build_context_ext.dart';
import 'phu_sphere.dart';

typedef BuildWhen<S> = bool Function(S previous, S current);
typedef SphereWidgetBuilder<S> = Widget Function(BuildContext context, S state);
typedef SphereBuildCallback<S> = void Function(BuildContext context, S state);

/// A [PhuStateBuilder] is a widget that rebuilds itself when the state of a [PhuSphere] changes.
///
/// This widget listens to a [PhuSphere] and calls the [builder] function whenever the state changes.
class PhuStateBuilder<P extends PhuSphere<S>, S> extends StatefulWidget {
  /// Creates a [PhuStateBuilder].
  ///
  /// The [sphere] and [builder] parameters are required.
  const PhuStateBuilder({
    super.key,
    this.sphere,
    this.buildWhen,
    required this.builder,
  });

  /// The [PhuSphere] that this builder listens to.
  final P? sphere;

  /// A callback function that determines whether the widget should be rebuilt
  /// based on changes in the state.
  ///
  /// If [buildWhen] is provided, it will be called with the previous and current
  /// state, and should return [true] if the widget should be rebuilt, or [false]
  /// if it should not.
  ///
  /// If [buildWhen] is not provided, the widget will be rebuilt whenever the state
  /// changes.
  ///
  /// Example usage:
  /// ```dart
  /// PhuStateBuilder<MySphere, int>(
  ///   buildWhen: (previous, current) => current % 2 == 0,
  ///   builder: (context, state) {
  ///     return Center(
  ///       child: Text(
  ///         "Ony rebuild when state % 2 == 0 \n\n$state",
  ///         style: Theme.of(context).textTheme.titleLarge,
  ///         textAlign: TextAlign.center,
  ///       ),
  ///     );
  ///   },
  /// )
  /// ```
  /// This can be useful for optimizing performance by preventing unnecessary rebuilds.
  final BuildWhen<S>? buildWhen;

  /// The builder function that is called whenever the state of the [PhuSphere] changes.
  ///
  /// The builder function takes the current state of the [PhuSphere] and the [BuildContext] as parameters
  /// and returns a widget.
  final Widget Function(BuildContext context, S state) builder;

  @override
  State<PhuStateBuilder<P, S>> createState() => _PhuStateBuilderState<P, S>();
}

class _PhuStateBuilderState<P extends PhuSphere<S>, S>
    extends State<PhuStateBuilder<P, S>> {
  P? _sphere;
  S? _state;

  @override
  void didUpdateWidget(PhuStateBuilder<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldSphere = oldWidget.sphere ?? context.read<P>();
    final currentSphere = widget.sphere ?? oldSphere;
    if (oldSphere != currentSphere) {
      _sphere = currentSphere;
      _state = _sphere!.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sphere = widget.sphere ?? context.read<P>();
    if (_sphere != sphere) {
      _sphere = sphere;
      _state = _sphere!.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PhuSphereListener(
      sphere: _sphere!,
      buildWhen: widget.buildWhen,
      buildCallBack: (context, S state) => setState(() => _state = state),
      child: widget.builder(context, _state as S),
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
