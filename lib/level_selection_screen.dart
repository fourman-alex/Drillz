import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pogo/fill_transition.dart';
import 'package:pogo/model.dart';
import 'package:pogo/workout_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Rect sourceRect;
  final List<Level> workouts;
  final Color color;

  const LevelSelectionScreen({
    Key key,
    @required this.sourceRect,
    this.workouts,
    this.color,
  })  : assert(sourceRect != null),
        super(key: key);

  /// [context] must be the [BuildContext] of the widget from which the
  /// transition will visually fill
  static Route<void> route(
    BuildContext context,
    List<Level> workouts,
    Color color,
  ) {
    final RenderBox box = context.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) => LevelSelectionScreen(
        sourceRect: sourceRect,
        workouts: workouts,
        color: color,
      ),
      transitionDuration: const Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //uses secondaryAnimation to slide this screen out when a new one covers it
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: child,
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
        ? workouts.getRange(0, lastCompletedIndex + 1).map((level) {
            return GestureDetector(
              onTap: () => Navigator.push(context, WorkoutScreen.route(level)),
              child: Opacity(
                opacity: 0.7,
                child: LevelPage(
                  workout: level,
                  text: "",
                  color: color,
                ),
              ),
            );
          }).expand((widget) => [
              widget,
              SizedBox(
                height: 20.0,
                width: double.infinity,
              )
            ]).toList()
        : null;

    return FillTransition(
      fromColor: color,
      toColor: color,
      source: sourceRect,
      child: Column(
        children: <Widget>[
          Expanded(
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
                        context, WorkoutScreen.route(currentWorkout));
                  },
                  child: LevelPage(
                    workout: currentWorkout,
                    text: "You have reached!",
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: SizedBox()),
          ),
        ],
      ),
    );
  }
}

class LevelPage extends StatelessWidget {
  final Level workout;
  final String text;
  final Color color;
  final void Function() onTap;

  const LevelPage({Key key, this.workout, this.text, this.color, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMEd();

    return Card(
      margin: EdgeInsets.only(
        left: 80.0,
      ),
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
            style: Theme.of(context).textTheme.subhead,
          ),
          Text(
            text ?? "",
            style: Theme.of(context).textTheme.headline,
          ),
//          if (workout.dateAttempted != null)
//            Text("Unlcoked on: ${dateFormat.format(workout.dateAttempted)}"),
//          if (workout.dateCompleted != null)
//            Text("Completed on: ${dateFormat.format(workout.dateCompleted)}"),
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
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              border: Border.all(color: color, width: 4.0),
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
