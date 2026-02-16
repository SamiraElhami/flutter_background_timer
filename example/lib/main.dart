import 'package:flutter/material.dart';
import 'package:background_timer_package/background_timer_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Background Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TimerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            BackgroundTimer(seconds: 60, controller: myController,
              storageManager: TimerStorageManager(),),
            ElevatedButton(
              onPressed: () => myController.pause(),
              child: Text("Pause"),
            ),
            ElevatedButton(
              onPressed: () => myController.resume(),
              child: Text("Resume"),
            ),
            ElevatedButton(
              onPressed: () => myController.reset(60),
              child: Text("Restart"),
            ),
          ],
      ),
      ),
    );
  }
}
