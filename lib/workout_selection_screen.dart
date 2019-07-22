import 'package:flutter/material.dart';
import 'package:pogo/plan.dart';
import 'package:pogo/positioned.dart';
import 'package:pogo/steps.dart';

import 'data_provider.dart' as DataProvider;

class WorkoutSelectionScreen extends StatefulWidget {
  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen> {
  List<Workout> _workouts;
  GlobalKey _pushupsKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      _workouts = [
        for (var rawWorkout in plan)
          Workout(
            rawWorkout["id"],
            rawWorkout["steps"],
            await DataProvider.getWorkoutDate(
                DataProvider.Date.attempted, rawWorkout["id"]),
            await DataProvider.getWorkoutDate(
                DataProvider.Date.completed, rawWorkout["id"]),
          )
      ];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              child: InkWell(
                child: Material(
                  key: _pushupsKey,
                  color: Colors.white,
                  child: Text("Pushups ink"),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    SelectionScreen.route(context, _pushupsKey),
                  );
                },
              ),
            ),
            Card(
              child: Text("Pushups"),
            ),
            Card(
              child: Text("Pushups"),
            ),
            Card(
              child: Text("Pushups"),
            ),
          ],
        ),
      ),
    );
  }
}
