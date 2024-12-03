import 'package:flutter/widgets.dart';

import 'phu_sphere.dart';

class PhuSphereProvider<T extends PhuSphere> extends InheritedWidget {
  const PhuSphereProvider({
    super.key,
    required this.sphere,
    required super.child,
  });

  final T sphere;

  static PhuSphereProvider<T>? _getProvider<T extends PhuSphere>(
      BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PhuSphereProvider<T>>();
  }

  static T? of<T extends PhuSphere>(BuildContext context) {
    return _getProvider<T>(context)?.sphere;
  }

  @override
  bool updateShouldNotify(PhuSphereProvider oldWidget) {
    return oldWidget.sphere != sphere;
  }
}
