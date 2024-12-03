import 'package:flutter/widgets.dart';

import 'phu_sphere.dart';

class PhuSphereProvider<T extends PhuSphere<S>, S> extends StatefulWidget {
  const PhuSphereProvider({
    super.key,
    required this.sphere,
    required this.child,
  });

  final T sphere;
  final Widget child;

  @override
  State<PhuSphereProvider<T, S>> createState() =>
      _PhuSphereProviderState<T, S>();

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

class _InheritedPhuSphereProvider<T extends PhuSphere> extends InheritedWidget {
  const _InheritedPhuSphereProvider({
    super.key,
    required this.sphere,
    required super.child,
  });

  final T sphere;

  @override
  bool updateShouldNotify(_InheritedPhuSphereProvider oldWidget) {
    return oldWidget.sphere != sphere;
  }
}
