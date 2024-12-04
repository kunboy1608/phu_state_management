import 'package:phu_state_management/phu_state_management.dart';

class MySphere extends PhuSphere<int> {
  MySphere(super.state);

  void increment() {
    final newState = state + 1;
    exude(newState);
  }
}
