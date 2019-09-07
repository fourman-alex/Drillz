import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pogo/model.dart';
import 'package:pogo/progress_button.dart';
import 'package:pogo/repository.dart';
import 'package:pogo/workout_screen_tiles.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key key, @required this.level}) : super(key: key);

  final Level level;

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();

  static PageRouteBuilder<void> route(Level level, ThemeData themeData) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (_, Animation<double> animation, __) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(0.0, 0.5),
          )),
          child: Theme(
            data: themeData,
            child: WorkoutScreen(
              level: level,
            ),
          ),
        );
      },
    );
  }
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin<WorkoutScreen> {
  final ValueNotifier<int> _currentStepIndexNotifier = ValueNotifier<int>(null);

  @override
  void initState() {
    _currentStepIndexNotifier.addListener(_handleCurrentStepChanged);
    _currentStepIndexNotifier.value = 0;
    //keep screen on while in this screen
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    _currentStepIndexNotifier.dispose();
    //disable the wakelock that keeps the screen on
    Wakelock.disable();
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
            providers: <SingleChildCloneableWidget>[
              ListenableProvider<ValueNotifier<int>>.value(
                value: _currentStepIndexNotifier,
              ),
              Provider<Level>.value(value: widget.level)
            ],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 5,
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
              size: 56,
              child: Icon(Icons.close),
              startColor: Theme.of(context).primaryColor,
              endColor: Theme.of(context).accentColor,
              onPressCompleted: () => Navigator.of(context).pop(),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCurrentStepChanged() {
    final ExerciseStep currentStep =
        widget.level.steps[_currentStepIndexNotifier.value];
    if (currentStep is FinishStep) {
      Repository.setWorkoutDate(
        Date.completed,
        widget.level.id,
        DateTime.now(),
      );
      //also reset model to null so that well have to load it and get
      // the updated values
      Provider.of<ValueNotifier<Model>>(context).value = null;
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
    final Level level = Provider.of<Level>(context, listen: false);
    final ValueNotifier<int> currentStepIndexNotifier =
        Provider.of<ValueNotifier<int>>(context);
    final ExerciseStep currentStep =
        level.steps[currentStepIndexNotifier.value];
    Widget center;
    if (currentStep is StartStep) {
      center = StartTile(
        onPressed: () => currentStepIndexNotifier.value++,
      );
    } else if (currentStep is FinishStep) {
      center = FinishTile();
    } else if (currentStep is RestStep) {
      center = RestTile(
        key: ValueKey<int>(currentStepIndexNotifier.value),
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
      duration: const Duration(milliseconds: 250),
    );
  }
}

class WorkoutStepsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> workoutStepsWidgets = <Widget>[];
    final UnmodifiableListView<ExerciseStep> workoutSteps =
        Provider.of<Level>(context, listen: false).steps;

    for (int i = 0; i < workoutSteps.length; ++i) {
      workoutStepsWidgets.add(
        Flexible(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Consumer<ValueNotifier<int>>(
              builder: (_, ValueNotifier<int> currentStepNotifier, __) {
                return GestureDetector(
                  onTap: () {
                    currentStepNotifier.value = i;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: currentStepNotifier.value == i
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        workoutSteps[i].toString(),
                        maxLines: 1,
                        style: TextStyle(
                          color: currentStepNotifier.value == i
                              ? Colors.white
                              : Colors.white54,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: workoutStepsWidgets,
      ),
    );
  }
}
