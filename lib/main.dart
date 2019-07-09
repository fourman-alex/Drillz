import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/workout_tiles.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      title: 'Pogo',
      home: Workout(),
    );
  }
}

enum StepType { work, rest }

class Step {
  final StepType stepType;
  final int amount;

  const Step(this.stepType, this.amount);
}

const List<Step> _steps = [
  Step(StepType.work, 5),
  Step(StepType.rest, 5),
  Step(StepType.work, 7),
  Step(StepType.rest, 5)
];

class Workout extends StatefulWidget {
  Workout({Key key}) : super(key: key);

  @override
  _WorkoutState createState() => _WorkoutState();
}

class CurrentStep extends ValueNotifier<int> {
  CurrentStep(int value) : super(value);
}

class _WorkoutState extends State<Workout> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider(
        builder: (_) => CurrentStep(null),
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
    var currentStep = Provider.of<CurrentStep>(context);
    Widget center;
    if (currentStep.value == null) {
      center = StartTile(
        onPressed: () => currentStep.value = 0,
      );
    } else if (currentStep.value >= _steps.length) {
      center = FinishTile();
    } else if (_steps[currentStep.value].stepType == StepType.rest) {
      center = RestTile(
        duration: _steps[currentStep.value].amount,
        onDone: () => currentStep.value++,
      );
    } else if (_steps[currentStep.value].stepType == StepType.work) {
      center = WorkTile(
        amount: _steps[currentStep.value].amount,
        onPressed: () => currentStep.value++,
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
    for (var i = 0; i < _steps.length; ++i) {
      var step = _steps[i];
      workoutSteps.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AspectRatio(
          aspectRatio: 1/1,
          child: Container(
            color: Provider.of<CurrentStep>(context).value == i ? Colors.lime : Colors.lime[100],
            child: GestureDetector(
              child: FittedBox(
                child: Text(step.amount.toString()),
              ),
              onTap: () {
                Provider.of<CurrentStep>(context).value = i;
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
