import 'package:drillz/model.dart';
import 'package:drillz/workout_screen.dart';
import 'package:flutter/material.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Material(
        child: WorkoutScreen(level: _level),
      ),
    );
  }
}

final List<ExerciseStep> _steps = <ExerciseStep>[
  StartStep(),
  WorkStep(16),
  RestStep(60),
  WorkStep(13),
  RestStep(60),
  WorkStep(11),
  RestStep(60),
  WorkStep(10),
  RestStep(60),
  WorkStep(9),
  RestStep(60),
  WorkStep(8),
  FinishStep(),
];

final Level _level = Level('level id', _steps, null, null);
