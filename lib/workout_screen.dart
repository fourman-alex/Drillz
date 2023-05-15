import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'consts.dart';
import 'model.dart';
import 'progress_button.dart';
import 'repository.dart';
import 'workout_screen_tiles.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    required this.level,
    Key? key,
  }) : super(key: key);

  final Level level;

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();

  static PageRouteBuilder<void> route({
    required Level level,
    required Rect sourceRect,
    required BorderRadius fromBorderRadius,
    required ThemeData theme,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) {
        return Theme(
          data: theme,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0.1, 0.0), end: Offset.zero)
                    .animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: WorkoutScreen(
                level: level,
              ),
            ),
          ),
        );
      },
    );
  }
}

// TODO(alex): change to stateless. the notifier can go to a provider on top of
//  this widget
class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin<WorkoutScreen> {
  final ValueNotifier<int> _currentStepIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    _currentStepIndexNotifier
      ..addListener(_handleCurrentStepChanged)
      ..value = 0;
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
    if (widget != oldWidget && widget.level != oldWidget.level) {
      _currentStepIndexNotifier.value = 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MultiProvider(
        providers: [
          ListenableProvider<ValueNotifier<int>>.value(
            value: _currentStepIndexNotifier,
          ),
          Provider<Level>.value(value: widget.level)
        ],
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: StepSwitcher(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: const WorkoutStepsBar(),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 16.0,
              end: 16.0,
              child: ProgressButton(
                size: 56,
                startColor: Theme.of(context).primaryColor,
                endColor: Theme.of(context).colorScheme.secondary,
                onPressCompleted: () => Navigator.of(context).pop(),
                color: Theme.of(context).primaryColor,
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCurrentStepChanged() {
    final ExerciseStep currentStep =
        widget.level.steps[_currentStepIndexNotifier.value];
    final Repository repository =
        Provider.of<Repository>(context, listen: false);
    if (currentStep is FinishStep) {
      repository.setWorkoutDate(
        Date.completed,
        widget.level.id,
        DateTime.now(),
      );
    } else if (currentStep is StartStep) {
      repository.setWorkoutDate(
        Date.attempted,
        widget.level.id,
        DateTime.now(),
      );
    }
  }
}

class StepSwitcher extends StatelessWidget {
  const StepSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Level level = Provider.of<Level>(context, listen: false);
    final ValueNotifier<int> currentStepIndexNotifier =
        Provider.of<ValueNotifier<int>>(context);
    final ExerciseStep currentStep =
        level.steps[currentStepIndexNotifier.value];
    late Widget center;
    if (currentStep is StartStep) {
      center = StartTile(
        onPressed: () => currentStepIndexNotifier.value++,
      );
    } else if (currentStep is FinishStep) {
      center = const FinishTile();
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: center,
    );
  }
}

class WorkoutStepsBar extends StatelessWidget {
  const WorkoutStepsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> workoutStepsWidgets = <Widget>[];
    final UnmodifiableListView<ExerciseStep> workoutSteps =
        Provider.of<Level>(context, listen: false).steps;

    for (int i = 0; i < workoutSteps.length; ++i) {
      workoutStepsWidgets.add(
        Flexible(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 1.3 / 1,
            child: Consumer<ValueNotifier<int>>(
              builder: (_, currentStepNotifier, __) {
                return GestureDetector(
                  onTap: () {
                    currentStepNotifier.value = i;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: currentStepNotifier.value == i
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        workoutSteps[i].toString(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: currentStepNotifier.value == i
                                  ? Colors.white
                                  : Colors.white54,
                              fontSize: 18.0,
                              fontFamily: Consts.righteousFont,
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
      if (i + 1 < workoutSteps.length) {
        workoutStepsWidgets.add(
          const Flexible(
            child: VerticalDivider(width: 1),
          ),
        );
      }
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: workoutStepsWidgets,
      ),
    );
  }
}
