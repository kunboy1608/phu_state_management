import 'package:flutter/material.dart';
import 'package:phu_state_management/phu_state_management.dart';
import 'package:phu_state_management_example/empty_screen.dart';

import 'sphere/my_sphere.dart';
import 'sphere/root_sphere.dart';

void main() {
  runApp(PhuSphereProvider(sphere: RootSphere(0), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhuSphereMultiProvider(
        spheres: [MySphere(0)],
        child: Scaffold(
          appBar: AppBar(
            title: PhuStateBuilder<RootSphere, int>(builder: (context, state) {
              return Text(
                  'Phu State management example: Running Time: $state (s) (using RootSphere)');
            }),
            centerTitle: true,
          ),
          body: Center(
            child: Wrap(
              children: [
                SizedBox.fromSize(
                  size: const Size.square(200),
                  child: Card.filled(
                    child: PhuStateBuilder<MySphere, int>(
                      builder: (context, state) {
                        return Center(
                          child: Text(
                            "Rebuild when state has changed\n\n$state",
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size.square(200),
                  child: Card.filled(
                    child: PhuStateBuilder<MySphere, int>(
                      buildWhen: (previous, current) => current % 2 == 0,
                      builder: (context, state) {
                        return Center(
                          child: Text(
                            "Ony rebuild when state % 2 == 0 \n\n$state",
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  return FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const EmptyScreen()));
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        minimumSize:
                            const WidgetStatePropertyAll(Size.square(200)),
                      ),
                      child: const Text('Open new screen to dispose MySphere'));
                }),
              ],
            ),
          ),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              tooltip: 'Increment',
              onPressed: () {
                context.read<MySphere>().increment();
              },
              child: const Icon(Icons.add),
            );
          }),
        ),
      ),
    );
  }
}
