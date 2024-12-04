import 'dart:async';

import 'package:phu_state_management/phu_state_management.dart';

class RootSphere extends PhuSphere<int> {
  RootSphere(super.state) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      increment();
    });
  }

  late Timer _timer;

  void increment() {
    final newState = state + 1;
    exude(newState);
  }

  @override
  void close() {
    _timer.cancel();
    super.close();
  }
}
