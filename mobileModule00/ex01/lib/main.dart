import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: ''),
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
  List<String> items = ['A simple text', 'Hello World'];
  int item_index = 0;

  void clickButton() {
    // itemsを切り替える
    setState(() {
      item_index = (item_index + 1) % items.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(items[item_index]),
            ElevatedButton(
              onPressed: clickButton,
              child: const Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }
}
