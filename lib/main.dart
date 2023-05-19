import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer show log;

extension Log on Object{
  void log() => developer.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

void testIt() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (i) => 'Stream 1, count = $i',
  );
  final stream2 = Stream.periodic(
    const Duration(seconds: 3),
    (i) => 'Stream 2, count = $i',
  );
  final combined = Rx.combineLatest2(stream1, stream2, (one, two) => 'one is $one, two is $two',);
  await for (final value in combined) {
    value.log();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    testIt();
    return const Placeholder();
  }
}
