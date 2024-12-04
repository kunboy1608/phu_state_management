import 'package:flutter/widgets.dart';

import 'phu_sphere.dart';
import 'phu_sphere_provider.dart';

/// A widget that provides multiple [PhuSphere] instances to its descendants.
///
/// [PhuSphereMultiProvider] is a [StatelessWidget] that takes a list of [PhuSphere]
/// instances and a child widget. It combines the spheres and provides them to
/// the widget tree using nested [PhuSphereProvider] widgets.
///
/// The [PhuSphereMultiProvider] class is generic and requires two type parameters:
/// - [P]: The type of the [PhuSphere] instances.
///
/// Example usage:
/// ```dart
/// PhuSphereMultiProvider<CustomSphere>(
///   spheres: [sphere1, sphere2, sphere3],
///   child: MyWidget(),
/// );
/// ```
///
/// The [PhuSphereMultiProvider] class ensures that each [PhuSphere] instance is
/// provided to the widget tree in a nested manner, allowing descendant widgets
/// to access the nearest [PhuSphere] instance of the specified type.
///
/// Properties:
/// - [spheres]: A list of [PhuSphere] instances to be provided to the widget tree.
/// - [child]: The child widget that will have access to the provided [PhuSphere] instances.
///
/// Methods:
/// - [_combine]: A private method that recursively wraps the child widget with
///   [PhuSphereProvider] widgets, each providing one of the [PhuSphere] instances.
///
/// The [build] method starts the combination process by calling [_combine] with
/// an initial index of 0.
class PhuSphereMultiProvider<P extends PhuSphere> extends StatelessWidget {
  const PhuSphereMultiProvider({
    super.key,
    required this.spheres,
    required this.child,
  });

  /// The list of [PhuSphere] instances to be provided to the widget tree.
  final List<P> spheres;

  /// The child widget that will have access to the provided [PhuSphere] instances.
  final Widget child;

  /// Combines the [PhuSphere] instances and provides them to the widget tree.
  ///
  /// This method recursively wraps the child widget with [PhuSphereProvider]
  /// widgets, each providing one of the [PhuSphere] instances.
  Widget _combine(int index) {
    if (index == spheres.length - 1) {
      return PhuSphereProvider(
        sphere: spheres[index],
        child: child,
      );
    }
    return PhuSphereProvider(
      sphere: spheres[index],
      child: _combine(index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _combine(0);
  }
}
