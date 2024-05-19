import 'package:flutter/material.dart';
import 'top_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 128, 71, 228)),
        useMaterial3: true,
      ),
      home: const TopPage(title: 'Flutter Demo Home Page'),
    );
  }
}
