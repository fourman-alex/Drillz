import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pogo/data_provider.dart' as DataProvider;
import 'package:pogo/plan.dart';
import 'package:pogo/steps.dart';

class StartScreen extends StatefulWidget {
  final ValueNotifier<List<Workout>> workoutsNotifier;

  const StartScreen(this.workoutsNotifier);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    loadWorkouts();
    super.initState();
  }

  Future loadWorkouts() async {
    var stopwatch = Stopwatch()..start();
    List<Workout> workouts = [
      for (var rawWorkout in plan)
        Workout(
          rawWorkout["id"],
          rawWorkout["steps"],
          await DataProvider.getWorkoutDate(
              DataProvider.Date.attempted, rawWorkout["id"]),
          await DataProvider.getWorkoutDate(
              DataProvider.Date.completed, rawWorkout["id"]),
        )
    ];
    //insures the start screen is displayed for at least 2 seconds
    //whether this is a good idea needs to be seen #todo
    await Future.delayed(
        Duration(milliseconds: 2000 - stopwatch.elapsedMilliseconds));
    widget.workoutsNotifier.value = workouts;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FittedBox(
          child: Text("Starting..."),
        ),
      ),
    );
  }
}
