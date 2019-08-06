import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/current_step_notifier.dart';
import 'package:pogo/model.dart';
import 'package:pogo/workout_screen_tiles.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  final Level workout;

  WorkoutScreen({Key key, @required this.workout})
      : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();

  static Route<dynamic> route(Level workout) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, _, __) {
        return WorkoutScreen(workout: workout,);
      },
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  CurrentStepNotifier _currentStepNotifier;

  @override
  void initState() {
    super.initState();
    _currentStepNotifier = CurrentStepNotifier(widget.workout);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider.value(
        value: _currentStepNotifier,
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
        onPressed: () => currentStepNotifier.currentStepIndex++,
      );
    } else if (currentStepNotifier.currentStep is FinishStep) {
      center = FinishTile();
    } else if (currentStepNotifier.currentStep is RestStep) {
      var restStep = currentStepNotifier.currentStep as RestStep;
      center = RestTile(
        key: ValueKey(currentStepNotifier.currentStepIndex),
        duration: restStep.duration,
        onDone: () => currentStepNotifier.currentStepIndex++,
      );
    } else if (currentStepNotifier.currentStep is WorkStep) {
      var workStep = currentStepNotifier.currentStep as WorkStep;
      center = WorkTile(
        reps: workStep.reps,
        onPressed: () => currentStepNotifier.currentStepIndex++,
      );
    }

    assert (center != null, "center has to be a Tile of some kind, it can't be null");

    return AnimatedSwitcher(
      child: center,
      duration: Duration(milliseconds: 500),
    );
  }
}

class WorkoutStepsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var workoutStepsWidgets = List<Widget>();
    var workoutSteps =
        Provider.of<CurrentStepNotifier>(context, listen: false).level.steps;

    for (var i = 0; i < workoutSteps.length; ++i) {
      workoutStepsWidgets.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Consumer<CurrentStepNotifier>(
              builder: (_, currentStepNotifier, __) {
                return Container(
                  color: currentStepNotifier.currentStepIndex == i
                      ? Colors.lime
                      : Colors.lime[100],
                  child: GestureDetector(
                    child: FittedBox(
                      child: Text(workoutSteps[i].toString()),
                    ),
                    onTap: () {
                      currentStepNotifier.currentStepIndex = i;
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: workoutStepsWidgets,
    );
  }
}
