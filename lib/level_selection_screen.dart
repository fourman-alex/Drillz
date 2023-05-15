import 'package:clippy_flutter/chevron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'calibration_banner.dart';
import 'consts.dart';
import 'fill_transition.dart';
import 'main.dart';
import 'model.dart';
import 'repository.dart';
import 'workout_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({
    required this.sourceRect,
    required this.workoutType,
    required this.title,
    Key? key,
  }) : super(key: key);

  final Rect sourceRect;
  final String title;
  final WorkoutType workoutType;

  /// [context] must be the [BuildContext] of the widget from which the
  /// transition will visually fill
  static Route<void> route({
    required BuildContext context,
    required String title,
    required WorkoutType workoutType,
    required Color fromColor,
    required Color toColor,
    required BorderRadius fromRadius,
    BorderRadius toRadius = BorderRadius.zero,
  }) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) {
        return FillTransition(
          source: sourceRect,
          fromColor: fromColor,
          toColor: toColor,
          fromBorderRadius: fromRadius,
          toBorderRadius: toRadius,
          child: Theme(
            data: ThemeData(
              brightness: Brightness.dark,
              primaryColor: fromColor,
              colorScheme:
                  Theme.of(context).colorScheme.copyWith(background: toColor),
              canvasColor: toColor,
              dividerColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: WillPopScope(
              onWillPop: () async {
                return !popAnimationObserver.isAnimating;
              },
              child: LevelSelectionScreen(
                sourceRect: sourceRect,
                workoutType: workoutType,
                title: title,
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    final ThemeData theme = Theme.of(context);
    final Color textColorOfCompleted =
        _darken(theme.textTheme.bodyMedium!.color!, 0.4);
    final Color cardColorOfCompleted = _darken(theme.primaryColor, 0.2);

    final Repository repository = Provider.of<Repository>(context);
    final List<Level> activeLevels =
        repository.model.getPlan(workoutType)!.activeLevels;
    for (int i = 0; i < activeLevels.length - 1; i++) {
      widgets.add(Builder(
        builder: (context) {
          return LevelPage(
            textColor: textColorOfCompleted,
            cardColor: cardColorOfCompleted,
            level: activeLevels[i],
          );
        },
      ));
    }
    widgets.add(LevelPage(
      level: activeLevels.last,
      textColor: theme.textTheme.bodyLarge!.color!,
      cardColor: theme.primaryColor,
    ));

    if (repository.model.getPlan(workoutType)!.notCalibrated) {
      widgets.add(
        CalibrationBanner(
          maxValue: 100 ~/ kCalibrationMultiplier,
          onCalibrate: (value) {
            repository.calibratePlan(workoutType, value);
          },
          onDismiss: () => repository.calibratePlan(workoutType, null),
          workoutString: Plan.getWorkoutTypeString(workoutType),
        ),
      );
    }
    // TODO(Alex): maybe just initially build it in correct order?
    widgets = widgets.reversed.toList();

    return DismissDetector(
      onDismiss: () => Navigator.of(context).pop(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            titleSpacing: 4.0,
            backgroundColor: theme.colorScheme.background,
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: Consts.righteousFont,
                fontSize: 30,
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(widgets)),
        ],
      ),
    );
  }

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}

class LevelPage extends StatelessWidget {
  LevelPage({
    required this.level,
    required this.textColor,
    required this.cardColor,
    Key? key,
  })  : _steps = level.steps.whereType<WorkStep>().toList(),
        _totalCount = level.total,
        super(key: key);

  final Level level;
  final List<WorkStep> _steps;
  final int _totalCount;
  final BorderRadius _borderRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(15),
    bottomRight: Radius.circular(15),
  );
  final Color textColor;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text.rich(
              TextSpan(
                text: '$_totalCount',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: Consts.righteousFont,
                  fontSize: 30,
                  color: textColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' in total',
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontFamily: Consts.righteousFont,
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final Rect sourceRect =
                        renderBox.localToGlobal(Offset.zero) & renderBox.size;
                    Navigator.push<void>(
                      context,
                      WorkoutScreen.route(
                        level: level,
                        sourceRect: sourceRect,
                        fromBorderRadius: _borderRadius,
                        theme: Theme.of(context),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: _borderRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          for (WorkStep step in _steps)
                            Expanded(
                              flex: 2,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Chevron(
                                  triangleHeight: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: textColor.withOpacity(0.3),
                                    ),
                                    child: SizedBox.expand(
                                      child: FittedBox(
                                        child: Text(
                                          step.reps.toString(),
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  color: textColor,
                                                  fontFamily:
                                                      Consts.righteousFont),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Detects swipe right and "zoom out" gesture
class DismissDetector extends StatelessWidget {
  const DismissDetector({
    required this.onDismiss,
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;
  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 10) {
          onDismiss();
        }
      },
      onScaleUpdate: (details) {
        if (details.scale < 0.9) {
          onDismiss();
        }
      },
      child: child,
    );
  }
}
