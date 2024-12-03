import 'package:flutter/material.dart';
import 'package:phu_state_management/phu_state_management.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mySphere = MySphere(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Phu State management example'),
        ),
        body: PhuStateBuilder<MySphere, int>(
          sphere: _mySphere,
          buildWhen: (previous, current) => current % 2 == 0,
          builder: (context, state) {
            return Text(state.toString());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _mySphere.increment();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MySphere extends PhuSphere<int> {
  MySphere(super.state);

  void increment() {
    state++;
    exude(state);
  }
}
