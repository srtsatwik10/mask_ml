import 'package:flutter/material.dart';
import 'package:mask_ml/home.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),);
  }
}

