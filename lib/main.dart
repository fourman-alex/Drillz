import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/current_step_notifier.dart';
import 'package:pogo/steps.dart';
import 'package:pogo/workout_screen.dart';
import 'package:pogo/workout_selection_screen.dart';

import 'start_screen.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CurrentStepNotifier _currentStepNotifier = CurrentStepNotifier();
  PageController _pageController = PageController();
  ValueNotifier<List<Workout>> _workoutsNotifier = ValueNotifier(null);

  @override
  void dispose() {
    _pageController.dispose();
    _currentStepNotifier.dispose();
    _workoutsNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _workoutsNotifier.addListener(_onWorkoutsListChanged);
    super.initState();
  }

  void _onWorkoutsListChanged() {
    if (_workoutsNotifier.value.isNotEmpty)
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuad);
    _workoutsNotifier.removeListener(_onWorkoutsListChanged);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      home: PageView.builder(
        itemCount: 3,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Widget page;
          switch (index) {
            case 0:
              page = StartScreen(_workoutsNotifier);
              break;
            case 1:
              page = WorkoutSelectionScreen(
                workouts: _workoutsNotifier.value,
                onWorkoutSelected: (workout) {
                  _currentStepNotifier.workout = workout;
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuad);
                },
              );
              break;
            case 2:
              page = WorkoutScreen(currentStepNotifier: _currentStepNotifier);
              break;
          }
          return page;
        },
      ),
    );
  }
}
