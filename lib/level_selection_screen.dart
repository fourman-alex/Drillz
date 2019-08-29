import 'package:flutter/material.dart';
import 'package:pogo/fill_transition.dart';
import 'package:pogo/model.dart';
import 'package:pogo/workout_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Rect sourceRect;
  final List<Level> workouts;

  const LevelSelectionScreen({
    Key key,
    @required this.sourceRect,
    this.workouts,
  })  : assert(sourceRect != null),
        super(key: key);

  /// [context] must be the [BuildContext] of the widget from which the
  /// transition will visually fill
  static Route<void> route({
    @required BuildContext context,
    @required List<Level> workouts,
    MaterialColor color,
    BorderRadius fromRadius,
    BorderRadius toRadius,
  }) {
    final RenderBox box = context.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) {
        return Theme(
          data: ThemeData(
            primarySwatch: color,
            accentColor: Colors.redAccent,
          ),
          child: LevelSelectionScreen(
            sourceRect: sourceRect,
            workouts: workouts,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //uses secondaryAnimation to slide this screen out when a new one covers it
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: FillTransition(
            source: sourceRect,
            child: child,
            fromColor: color,
            toColor: color,
            fromBorderRadius: fromRadius,
            toBorderRadius: toRadius,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //find last completed
    var lastCompletedIndex =
        workouts.lastIndexWhere((workout) => workout.dateCompleted != null);
    var currentWorkout = lastCompletedIndex + 1 < workouts.length
        ? workouts[lastCompletedIndex + 1]
        : null;

    List<Widget> completedList = lastCompletedIndex != -1
        ? workouts
            .getRange(0, lastCompletedIndex + 1)
            .map((level) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  WorkoutScreen.route(
                    level,
                    Theme.of(context),
                  ),
                ),
                child: Opacity(
                  opacity: 0.7,
                  child: LevelPage(
                    workout: level,
                    text: "",
                  ),
                ),
              );
            })
            .expand((widget) => [
                  widget,
                  SizedBox(
                    height: 20.0,
                    width: double.infinity,
                  )
                ])
            .toList()
        : null;

    return DismissDetector(
      child: ListView(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ...?completedList,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              debugPrint("current workout tapped");
              Navigator.push(
                  context,
                  WorkoutScreen.route(
                    currentWorkout,
                    Theme.of(context),
                  ));
            },
            child: LevelPage(
              workout: currentWorkout,
              text: "You have reached!",
            ),
          ),
        ],
      ),
      onDismiss: () => Navigator.of(context).pop(),
    );
  }
}

class LevelPage extends StatelessWidget {
  final Level workout;
  final String text;
  final void Function() onTap;

  const LevelPage({Key key, this.workout, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            workout.id,
            style: Theme.of(context).accentTextTheme.title,
          ),
          Expanded(
            flex: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for (var step in workout.steps)
                  if (step is WorkStep)
                    Expanded(
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
                                  style:
                                      Theme.of(context).accentTextTheme.body1,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    )
              ],
            ),
          ),
        ],
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
