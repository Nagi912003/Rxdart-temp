import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  // <-- HookWidget: for using textEditingController without using Stateful widget
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create our behavior subject every time widget rebuilds
    final subject = useMemoized(
      // <-- BehaviorSubject: internally uses StreamController which allows read and write access to the stream
      // while sink.add() only allows write access, and stream.listen() only allows read access
      () => BehaviorSubject<String>(),
      [key],
    );
    //dispose of the old subject every time widget is rebuilt
    useEffect(
      () => subject.close,
      [subject],
    );

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          // <-- StreamBuilder: listens to the stream and rebuilds the widget when the stream emits a new value
          stream: subject.stream
              .distinct()
              .debounceTime(const Duration(milliseconds: 500)),
          initialData: 'please start typing',
          builder: (context, snapshot) {
            return Text(snapshot.requireData);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Enter your name',
            ),
            onChanged: subject.sink.add,
          ),
        ),
      ),
    );
  }
}
