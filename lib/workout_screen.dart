import 'package:flutter/material.dart';
import 'package:pogo/audio.dart';
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

  static Route<dynamic> route(Level level, ThemeData themeData) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, _, __) {
        return Theme(
          data: themeData,
          child: WorkoutScreen(
            level: level,
          ),
        );
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
      color: Theme.of(context).primaryColorDark,
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
              width: 80,
              height: 80,
              text: Text(
                "BAIL",
                style: TextStyle(color: Colors.white),
              ),
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
    player.play("soft-bells.mp3");
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
      duration: Duration(milliseconds: 250),
    );
  }
}

class WorkoutStepsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var workoutStepsWidgets = List<Widget>();
    var workoutSteps = Provider.of<Level>(context, listen: false).steps;

    for (var i = 0; i < workoutSteps.length; ++i) {
      workoutStepsWidgets.add(
        Flexible(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Consumer<ValueNotifier<int>>(
              builder: (_, currentStepNotifier, __) {
                return GestureDetector(
                  onTap: () {
                    currentStepNotifier.value = i;
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
