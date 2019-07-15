import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/page_switcher.dart';
import 'package:pogo/plan.dart';
import 'package:pogo/steps.dart';
import 'package:pogo/workout_selection_screen.dart';
import 'package:pogo/workout_tiles.dart';
import 'package:provider/provider.dart';
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
                  _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuad);
                },
              );
              break;
            case 1:
              page = WorkoutWidget(currentStepNotifier: _currentStepNotifier);
              break;
          }
          return page;
        },
      ),
    );
  }
}

class WorkoutWidget extends StatefulWidget {
  final CurrentStepNotifier currentStepNotifier;

  WorkoutWidget({Key key, @required this.currentStepNotifier})
      : super(key: key);

  @override
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider.value(
        value: widget.currentStepNotifier,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: StepSwitcher(),
            ),
            Expanded(
              flex: 1,
              child: WorkoutStepsBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class StepSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentStepNotifier = Provider.of<CurrentStepNotifier>(context);
    Widget center;
    if (currentStepNotifier.currentStep is StartStep) {
      center = StartTile(
        onPressed: () => currentStepNotifier.incrementStep(),
      );
    } else if (currentStepNotifier.currentStep is FinishStep) {
      center = FinishTile();
    } else if (currentStepNotifier.currentStep is RestStep) {
      var restStep = currentStepNotifier.currentStep as RestStep;
      center = RestTile(
        key: ValueKey(currentStepNotifier.currentStepIndex),
        duration: restStep.duration,
        onDone: () => currentStepNotifier.incrementStep(),
      );
    } else if (currentStepNotifier.currentStep is WorkStep) {
      var workStep = currentStepNotifier.currentStep as WorkStep;
      center = WorkTile(
        reps: workStep.reps,
        onPressed: () => currentStepNotifier.incrementStep(),
      );
    }

    if (center == null) throw Error();

    return AnimatedSwitcher(
      child: center,
      duration: Duration(milliseconds: 500),
    );
  }
}

class WorkoutStepsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var workoutSteps = List<Widget>();
    var currentStepNotifier = Provider.of<CurrentStepNotifier>(context);

    for (var i = 0; i < currentStepNotifier.workout.length; ++i) {
      workoutSteps.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            color: currentStepNotifier.currentStepIndex == i
                ? Colors.lime
                : Colors.lime[100],
            child: GestureDetector(
              child: FittedBox(
                child: Text(currentStepNotifier.workout[i].toString()),
              ),
              onTap: () {
                currentStepNotifier.currentStepIndex = i;
              },
            ),
          ),
        ),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: workoutSteps,
    );
  }
}
