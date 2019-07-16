import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/data_provider.dart' as DataProvider;
import 'package:pogo/plan.dart';
import 'package:pogo/steps.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  final List<Workout> workouts;
  final void Function(Workout workout) onWorkoutSelected;

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

    var attemptedDateFuture = DataProvider.getWorkoutAttempted(workout.id);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: rects,
        ),
        FutureBuilder<DateTime>(
          future: attemptedDateFuture,
          builder: (context, snap) {
            if (snap.hasData) return Text("Attempted on: ${snap.data}");
            return Text('');
          },
        ),
      ],
    );
  }
}
