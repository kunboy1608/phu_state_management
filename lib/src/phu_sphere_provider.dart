import 'package:flutter/widgets.dart';

import 'phu_sphere.dart';

/// A `PhuSphereProvider` is a `StatefulWidget` that provides a `PhuSphere` to its descendants.
///
/// This widget is used to make a `PhuSphere` available to the widget tree below it.
class PhuSphereProvider<T extends PhuSphere<S>, S> extends StatefulWidget {
  /// Creates a `PhuSphereProvider`.
  ///
  /// The [sphere] and [child] parameters are required.
  const PhuSphereProvider({
    super.key,
    required this.sphere,
    required this.child,
  });

  /// The `PhuSphere` that this provider makes available to its descendants.
  final T sphere;

  /// The widget below this provider in the tree.
  final Widget child;

  @override
  State<PhuSphereProvider<T, S>> createState() =>
      _PhuSphereProviderState<T, S>();

  /// Retrieves the nearest `PhuSphere` of type [T] from the given [BuildContext].
  ///
  /// Returns `null` if no such `PhuSphere` is found.
  static T? of<T extends PhuSphere>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_InheritedPhuSphereProvider<T>>();
    return provider?.sphere;
  }
}

class _PhuSphereProviderState<T extends PhuSphere<S>, S>
    extends State<PhuSphereProvider<T, S>> {
  @override
  Widget build(BuildContext context) {
    return _InheritedPhuSphereProvider<T>(
      sphere: widget.sphere,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.sphere.close();
    super.dispose();
  }
}

/// An inherited widget that holds a reference to a `PhuSphere`.
///
/// This widget is used internally by `PhuSphereProvider` to make the `PhuSphere` available to the widget tree.
class _InheritedPhuSphereProvider<T extends PhuSphere> extends InheritedWidget {
  /// Creates an `_InheritedPhuSphereProvider`.
  ///
  /// The [sphere] and [child] parameters are required.
  const _InheritedPhuSphereProvider({
    required this.sphere,
    required super.child,
  });

  /// The `PhuSphere` that this inherited widget holds.
  final T sphere;

  @override
  bool updateShouldNotify(_InheritedPhuSphereProvider<T> oldWidget) {
    return sphere != oldWidget.sphere;
  }
}
