import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/fill_transition.dart';
import 'package:pogo/model.dart';
import 'package:pogo/workout_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Rect sourceRect;
  final List<Level> workouts;
  final Level currentWorkout;
  final String title;

  const LevelSelectionScreen({
    Key key,
    @required this.sourceRect,
    this.workouts,
    this.currentWorkout,
    @required this.title,
  })  : assert(sourceRect != null),
        super(key: key);

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
    final pageContent = Theme(
      data: Theme.of(context).copyWith(
        primaryColor: fromColor,
        backgroundColor: toColor,
        canvasColor: toColor,
        dividerColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      child: LevelSelectionScreen(
        sourceRect: sourceRect,
        workouts: workouts,
        currentWorkout: currentWorkout,
        title: title,
      ),
    );
    final fillTransition = FillTransition(
      source: sourceRect,
      child: pageContent,
      fromColor: fromColor,
      toColor: toColor,
      fromBorderRadius: fromRadius,
      toBorderRadius: toRadius,
    );
    return PageRouteBuilder<void>(
      maintainState: false,
      pageBuilder: (BuildContext context, _, secondaryAnimation) {
        return fillTransition;
      },
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    //find last completed
    var widgets = List<Widget>();

    if (workouts != null) {
      for (var i = 0; i < workouts.length; i++) {
        widgets.add(LevelPage(
          onTap: () {
            Navigator.push(
                context,
                WorkoutScreen.route(
                  workouts[i],
                  Theme.of(context),
                ));
          },
          text: "Level ${i + 1}",
          opacity: 0.7,
          level: workouts[i],
        ));
      }
    }

    if (currentWorkout != null) {
      widgets.add(LevelPage(
        onTap: () {
          Navigator.push(
              context,
              WorkoutScreen.route(
                currentWorkout,
                Theme.of(context),
              ));
        },
        text: "Level ${(workouts?.length ?? 0) + 1}",
        opacity: 1.0,
        level: currentWorkout,
      ));
    }

    return DismissDetector(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            titleSpacing: 4.0,
            backgroundColor: Theme.of(context).backgroundColor,
            title: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: Consts.righteousFont,
                  fontSize: 40,
                ),
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
  final List<WorkStep> _steps;
  final int _totalCount;
  final String text;
  final void Function() onTap;
  final double opacity;

  LevelPage({Key key, Level level, this.text, this.opacity, this.onTap})
      : _steps = level.steps
            .where((step) => step is WorkStep)
            .cast<WorkStep>()
            .toList(),
        _totalCount = level.steps
            .where((step) => step is WorkStep)
            .cast<WorkStep>()
            .fold(0, (value, step) => value + step.reps),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: opacity,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //todo: build the steps in the init method
                      for (var step in _steps)
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    child: Text(
                                      step.reps.toString(),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .accentTextTheme
                                          .body1
                                          .copyWith(
                                              fontFamily: Consts.righteousFont),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FittedBox(
                              child: Text(
                                  _totalCount.toString().padLeft(2, '  '))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detects swipe right and "zoom out" gesture
class DismissDetector extends StatelessWidget {
  final Widget child;
  final void Function() onDismiss;

  const DismissDetector({
    Key key,
    this.child,
    @required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta > 10) {
          onDismiss();
        }
      },
      onScaleUpdate: (details) {
        if (details.scale < 0.9) {
          onDismiss();
        }
      },
    );
  }
}
