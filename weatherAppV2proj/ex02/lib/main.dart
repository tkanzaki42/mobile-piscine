import 'package:flutter/material.dart';
import 'weather_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  const String fileName = '.env';
  await dotenv.load(fileName: fileName);
  runApp(const WeatherApp());
}
