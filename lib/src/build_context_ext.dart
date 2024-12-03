import 'package:flutter/widgets.dart';

import 'phu_sphere.dart';
import 'phu_sphere_provider.dart';

extension SphereRead on BuildContext {
  T read<T extends PhuSphere>() {
    return PhuSphereProvider.of<T>(this)!;
  }
}
