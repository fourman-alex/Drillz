import 'package:flutter/material.dart';
import 'package:pogo/model.dart';
import 'package:pogo/level_selection_screen.dart';

import 'data_provider.dart' as DataProvider;

class WorkoutSelectionScreen extends StatefulWidget {
  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen> {
  List<Workout> _workouts;

  ValueNotifier<WorkoutSelection> _modelValueNotifier = ValueNotifier(null);

  @override
  void initState() {
    //we need to load all workout data
    DataProvider.modelAsync
        .then((model) => _modelValueNotifier.value = model);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ValueListenableBuilder<WorkoutSelection>(
        valueListenable: _modelValueNotifier,
        builder: (_, model, __) {
          //create indicator
          Widget progressIndicator;
          if (model == null) {
            progressIndicator = CircularProgressIndicator();
          } else
            progressIndicator = Container();

          return Column(
            children: <Widget>[
              Center(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: <Widget>[
                    Card(
                      child: Builder(
                        builder: (context) => InkWell(
                          child: Material(
                            color: model != null ? Colors.white : Colors.red,
                            child: Text("Pushups ink"),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              LevelSelectionScreen.route(context, model.pushUpsPlan, null),
                            );
                          },
                        ),
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
              AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: progressIndicator,
              ),
            ],
          );
        },
      ),
    );
  }
}
