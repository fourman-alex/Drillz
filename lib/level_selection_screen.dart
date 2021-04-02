import 'package:clippy_flutter/chevron.dart';
import 'package:drillz/calibration_banner.dart';
import 'package:drillz/consts.dart';
import 'package:drillz/fill_transition.dart';
import 'package:drillz/main.dart';
import 'package:drillz/model.dart';
import 'package:drillz/repository.dart';
import 'package:drillz/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({
    Key? key,
    required this.sourceRect,
    required this.workoutType,
    required this.title,
  })   : assert(sourceRect != null),
        super(key: key);

  final Rect sourceRect;
  final String title;
  final WorkoutType workoutType;

  /// [context] must be the [BuildContext] of the widget from which the
  /// transition will visually fill
  static Route<void> route({
    required BuildContext context,
    required String title,
    required WorkoutType workoutType,
    required MaterialColor fromColor,
    required Color toColor,
    required BorderRadius fromRadius,
    BorderRadius toRadius = BorderRadius.zero,
  }) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;
    return PageRouteBuilder<void>(
      maintainState: true,
      pageBuilder: (_, __, ___) {
        return FillTransition(
          source: sourceRect,
          child: Theme(
            data: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: fromColor,
              primaryColor: fromColor,
              primaryColorDark: fromColor.shade800,
              backgroundColor: toColor,
              canvasColor: toColor,
              dividerColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
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
          fromColor: fromColor,
          toColor: toColor,
          fromBorderRadius: fromRadius,
          toBorderRadius: toRadius,
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
        _darken(theme.textTheme.bodyText2!.color!, 0.4);
    final Color cardColorOfCompleted = _darken(theme.primaryColor, 0.2);

    final Repository repository = Provider.of<Repository>(context);
    final List<Level> activeLevels =
        repository.value.getPlan(workoutType)!.activeLevels;
    if (activeLevels != null) {
      for (int i = 0; i < activeLevels.length - 1; i++) {
        widgets.add(Builder(
          builder: (BuildContext context) {
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
        textColor: theme.textTheme.bodyText1!.color!,
        cardColor: theme.primaryColor,
      ));
    }

    if (repository.value.getPlan(workoutType)!.notCalibrated) {
      widgets.add(
        CalibrationBanner(
          maxValue: 100 ~/ kCalibrationMultiplier,
          onCalibrate: (int value) {
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
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: true,
            titleSpacing: 4.0,
            backgroundColor: theme.backgroundColor,
            title: Text(
              title,
              style: TextStyle(
                fontFamily: Consts.righteousFont,
                fontSize: 30,
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(widgets)),
        ],
      ),
      onDismiss: () => Navigator.of(context).pop(),
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
    Key? key,
    required this.level,
    required this.textColor,
    required this.cardColor,
  })   : _steps = level.steps.whereType<WorkStep>().toList(),
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
                style: theme.textTheme.body1!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: Consts.righteousFont,
                  fontSize: 30,
                  color: textColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' in total',
                    style: theme.textTheme.display1!.copyWith(
                      fontFamily: Consts.righteousFont,
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (BuildContext context) {
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
                                    child: SizedBox.expand(
                                      child: FittedBox(
                                        child: Text(
                                          step.reps.toString(),
                                          textAlign: TextAlign.center,
                                          style: theme.accentTextTheme.body1!
                                              .copyWith(
                                                  color: textColor,
                                                  fontFamily:
                                                      Consts.righteousFont),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: textColor.withOpacity(0.3),
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
    Key? key,
    this.child,
    required this.onDismiss,
  }) : super(key: key);

  final Widget? child;
  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.primaryDelta! > 10) {
          onDismiss();
        }
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        if (details.scale < 0.9) {
          onDismiss();
        }
      },
    );
  }
}
