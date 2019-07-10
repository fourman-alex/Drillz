import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/steps.dart';
import 'package:pogo/workout_tiles.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      title: 'Pogo',
      home: WorkoutWidget(),
    );
  }
}

const List<ExerciseStep> _steps = [
  StartStep(),
  WorkStep(5),
  RestStep(10),
  WorkStep(5),
  RestStep(10),
  FinishStep(),
];

class WorkoutWidget extends StatefulWidget {
  WorkoutWidget({Key key}) : super(key: key);

  @override
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider(
        builder: (_) => CurrentStepNotifier(_steps),
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

    for (var i = 0; i < currentStepNotifier.plan.length; ++i) {
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
                child: Text(currentStepNotifier.plan[i].toString()),
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
