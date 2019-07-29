import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/workout_selection_screen.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      home: WorkoutSelectionScreen(),
    );
  }
}
