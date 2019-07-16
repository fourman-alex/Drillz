import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/current_step_notifier.dart';
import 'package:pogo/plan.dart';
import 'package:pogo/workout_screen.dart';
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
  CurrentStepNotifier _currentStepNotifier = CurrentStepNotifier();
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    _currentStepNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      home: PageView.builder(
        itemCount: 2,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Widget page;
          switch (index) {
            case 0:
              page = WorkoutSelectionScreen(
                workouts: plan,
                onWorkoutSelected: (workout) {
                  _currentStepNotifier.steps = workout.steps;
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuad);
                },
              );
              break;
            case 1:
              page = WorkoutScreen(currentStepNotifier: _currentStepNotifier);
              break;
          }
          return page;
        },
      ),
    );
  }
}
