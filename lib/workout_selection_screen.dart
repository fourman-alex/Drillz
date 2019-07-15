import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/plan.dart';
import 'package:pogo/steps.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  final List<Workout> workouts;
  final Function(Workout workout) onWorkoutSelected;

  const WorkoutSelectionScreen({
    Key key,
    @required this.workouts,
    this.onWorkoutSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //create list items
    var widgets = List<Widget>();
    for (var workout in workouts) {
      var listItem = WorkoutListTile(
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
                child: WorkoutListTile(
                  workout: workout,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class WorkoutListTile extends StatelessWidget {
  final Workout workout;

  const WorkoutListTile({Key key, @required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buildRepRects() {
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
      return rects;
    }

    List<WorkStep> workSteps = [
      ...workout.steps.where((step) => step is WorkStep)
    ];
    var repsCount = workSteps
        .map((step) => step.reps)
        .reduce((value, element) => value + element);
    return Stack(
      children: <Widget>[
//        Positioned.fill(
//          child: FittedBox(
//            child: Text(repsCount.toString(), style: TextStyle(color: Colors.deepOrangeAccent),),
//          ),
//        ),
        Row(
          children: buildRepRects(),
        ),
      ],
    );
  }
}
