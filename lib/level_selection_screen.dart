import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pogo/fill_transition.dart';
import 'package:pogo/model.dart';
import 'package:pogo/workout_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Rect sourceRect;
  final List<Workout> workouts;

  const LevelSelectionScreen({
    Key key,
    @required this.sourceRect,
    this.workouts,
  })  : assert(sourceRect != null),
        super(key: key);

  /// [context] must be the [BuildContext] of the widget from which the
  /// transition will visually fill
  static Route<void> route(
    BuildContext context,
    List<Workout> workouts,
  ) {
    final RenderBox box = context.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) => LevelSelectionScreen(
        sourceRect: sourceRect,
        workouts: workouts,
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
    var lastWorkout =
        lastCompletedIndex != -1 ? workouts[lastCompletedIndex] : null;
    var currentWorkout = lastCompletedIndex + 1 < workouts.length
        ? workouts[lastCompletedIndex + 1]
        : null;

    return FillTransition(
      source: sourceRect,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: PageController(viewportFraction: 1.0),
              children: <Widget>[
                if (lastWorkout != null)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: LevelPage(
                      workout: lastWorkout,
                      text: "Last",
                    ),
                  ),
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
  final Workout workout;
  final String text;
  final void Function() onTap;

  const LevelPage({Key key, this.workout, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMEd();

    return Card(
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
          if (workout.dateAttempted != null)
            Text("Unlcoked on: ${dateFormat.format(workout.dateAttempted)}"),
          if (workout.dateCompleted != null)
            Text("Completed on: ${dateFormat.format(workout.dateCompleted)}"),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for (var step in workout.steps)
                  if (step is WorkStep) Text(step.reps.toString())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
