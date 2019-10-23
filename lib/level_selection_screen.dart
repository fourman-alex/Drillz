import 'package:clippy_flutter/chevron.dart';
import 'package:drillz/consts.dart';
import 'package:drillz/fill_transition.dart';
import 'package:drillz/main.dart';
import 'package:drillz/model.dart';
import 'package:drillz/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tinycolor/tinycolor.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({
    Key key,
    @required this.sourceRect,
    this.workouts,
    this.currentWorkout,
    @required this.title,
  })  : assert(sourceRect != null),
        super(key: key);

  final Rect sourceRect;
  final List<Level> workouts;
  final Level currentWorkout;
  final String title;

  /// [context] must be the [BuildContext] of the widget from which the
  /// transition will visually fill
  static Route<void> route({
    @required BuildContext context,
    @required String title,
    List<Level> workouts,
    Level currentWorkout,
    @required MaterialColor fromColor,
    @required Color toColor,
    BorderRadius fromRadius,
    BorderRadius toRadius,
  }) {
    final RenderBox box = context.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;
    return PageRouteBuilder<void>(
      maintainState: true,
      pageBuilder: (_, __, ___) {
        return FillTransition(
          source: sourceRect,
          child: Theme(
            data: Theme.of(context).copyWith(
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
                workouts: workouts,
                currentWorkout: currentWorkout,
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
    //find last completed
    List<Widget> widgets = <Widget>[];
    final ThemeData theme = Theme.of(context);
    final Color textColorOfCompleted =
        TinyColor(theme.textTheme.body1.color).darken(40).color;
    final Color cardColorOfCompleted =
        TinyColor(theme.primaryColor).darken(20).color;

    if (workouts != null) {
      for (int i = 0; i < workouts.length; i++) {
        widgets.add(Builder(
          builder: (BuildContext context) {
            return LevelPage(
              textColor: textColorOfCompleted,
              cardColor: cardColorOfCompleted,
              level: workouts[i],
            );
          },
        ));
      }
    }

    if (currentWorkout != null) {
      widgets.add(LevelPage(
        level: currentWorkout,
        textColor: theme.textTheme.body1.color,
        cardColor: theme.primaryColor,
      ));
    }

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
}

class LevelPage extends StatelessWidget {
  LevelPage({
    Key key,
    @required this.level,
    @required this.textColor,
    @required this.cardColor,
  })  : _steps = level.steps.whereType<WorkStep>().toList(),
        _totalCount = level.steps
            .whereType<WorkStep>()
            .fold(0, (int value, WorkStep step) => value + step.reps),
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
                style: theme.textTheme.body1.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: Consts.righteousFont,
                  fontSize: 35,
                  color: textColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' in total',
                    style: theme.textTheme.display1.copyWith(
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
                    final RenderBox renderBox = context.findRenderObject();
                    final Rect sourceRect =
                        renderBox.localToGlobal(Offset.zero) & renderBox.size;
                    Navigator.push<void>(
                      context,
                      WorkoutScreen.route(
                        level: level,
                        sourceRect: sourceRect,
                        fromBorderRadius: _borderRadius,
                        theme: Theme.of(context),
                        fromColor: cardColor,
                      ),
                    );
                  },
                  child: Container(
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
                                          style: theme.accentTextTheme.body1
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
    Key key,
    this.child,
    @required this.onDismiss,
  }) : super(key: key);

  final Widget child;
  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.primaryDelta > 10) {
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
