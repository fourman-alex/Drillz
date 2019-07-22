import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pogo/steps.dart';

class LevelSelectionScreen extends StatelessWidget {
  final List<Workout> workouts;
  final void Function(Workout workout) onWorkoutSelected;

  const LevelSelectionScreen({
    Key key,
    @required this.workouts,
    this.onWorkoutSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //create list items
    var widgets = List<Widget>();
    for (var workout in workouts) {
      var listItem = LevelListTile(
        workout: workout,
      );
      widgets.add(listItem);
    }

    return Material(
      child: Container(
        child: ListView(
          children: <Widget>[
            for (var workout in workouts)
              GestureDetector(
                onTap: () => onWorkoutSelected(workout),
                child: LevelListTile(
                  workout: workout,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class LevelListTile extends StatelessWidget {
  final Workout workout;

  const LevelListTile({Key key, @required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rects = List<Widget>();
    var i = 0;
    for (var step in workout.steps) {
      if (step is WorkStep) {
        rects.add(Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            height: 50.0,
            color: (i % 2) == 0 ? Colors.lightBlue[100] : Colors.pink[100],
            child: FittedBox(
                child: Text(
              step.toString(),
              textAlign: TextAlign.center,
            )),
          ),
          flex: step.reps,
        ));
        i++;
      }
    }

    var dateFormat = DateFormat.yMEd();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: rects,
        ),
        Row(
          children: <Widget>[
            if (workout.dateAttempted != null)
              Text("Attempted on: ${dateFormat.format(workout.dateAttempted)}"),
            if (workout.dateCompleted != null)
              Text("Completed on: ${dateFormat.format(workout.dateCompleted)}"),
          ],
        ),
      ],
    );
  }
}
