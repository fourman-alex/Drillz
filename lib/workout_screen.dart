import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/model.dart';
import 'package:pogo/progress_button.dart';
import 'package:pogo/repository.dart';
import 'package:pogo/workout_screen_tiles.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  final Level level;

  WorkoutScreen({Key key, @required this.level}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();

  static Route<dynamic> route(Level level, {Color primaryColor}) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, _, __) {
        var workoutScreen = WorkoutScreen(
          level: level,
        );
        return primaryColor != null
            ? Theme(
                data: Theme.of(context).copyWith(primaryColor: primaryColor),
                child: workoutScreen)
            : workoutScreen;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin<WorkoutScreen> {
  ValueNotifier<int> _currentStepIndexNotifier = ValueNotifier(null);

  @override
  void initState() {
    _currentStepIndexNotifier.addListener(_handleCurrentStepChanged);
    _currentStepIndexNotifier.value = 0;
    super.initState();
  }

  @override
  void dispose() {
    _currentStepIndexNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WorkoutScreen oldWidget) {
    //reset the index if the level changed
    if (widget != oldWidget && widget.level != oldWidget.level)
      _currentStepIndexNotifier.value = 0;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          MultiProvider(
            providers: [
              ListenableProvider<ValueNotifier<int>>.value(
                value: _currentStepIndexNotifier,
              ),
              Provider<Level>.value(value: widget.level)
            ],
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
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 16.0,
            start: 16.0,
            child: ProgressButton(
              width: 80,
              height: 80,
              text: "BAIL",
              startColor: Colors.redAccent,
              endColor: Colors.red,
              onPressCompleted: () => Navigator.of(context).pop(),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCurrentStepChanged() {
    var currentStep = widget.level.steps[_currentStepIndexNotifier.value];
    if (currentStep is FinishStep) {
      Repository.setWorkoutDate(
        Date.completed,
        widget.level.id,
        DateTime.now(),
      );
    } else if (currentStep is StartStep) {
      Repository.setWorkoutDate(
        Date.attempted,
        widget.level.id,
        DateTime.now(),
      );
    }
  }
}

class StepSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var level = Provider.of<Level>(context, listen: false);
    var currentStepIndexNotifier = Provider.of<ValueNotifier<int>>(context);
    var currentStep = level.steps[currentStepIndexNotifier.value];
    Widget center;
    if (currentStep is StartStep) {
      center = StartTile(
        onPressed: () => currentStepIndexNotifier.value++,
      );
    } else if (currentStep is FinishStep) {
      center = FinishTile();
    } else if (currentStep is RestStep) {
      center = RestTile(
        key: ValueKey(currentStepIndexNotifier.value),
        duration: currentStep.duration,
        onDone: () => currentStepIndexNotifier.value++,
      );
    } else if (currentStep is WorkStep) {
      center = WorkTile(
        reps: currentStep.reps,
        onPressed: () => currentStepIndexNotifier.value++,
      );
    }

    assert(center != null,
        "center has to be a Tile of some kind, it can't be null");

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
    var workoutSteps = Provider.of<Level>(context, listen: false).steps;

    for (var i = 0; i < workoutSteps.length; ++i) {
      workoutStepsWidgets.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Consumer<ValueNotifier<int>>(
              builder: (_, currentStepNotifier, __) {
                return Container(
                  color: currentStepNotifier.value == i
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.4),
                  child: GestureDetector(
                    child: FittedBox(
                      child: Text(workoutSteps[i].toString()),
                    ),
                    onTap: () {
                      currentStepNotifier.value = i;
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
