import 'package:flutter/material.dart';
import 'package:pogo/level_selection_screen.dart';
import 'package:pogo/model.dart';

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
    DataProvider.modelAsync.then((model) => _modelValueNotifier.value = model);

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
                    _WorkoutButton(
                      text: "pushups",
                      plan: model?.pushUpsPlan,
                    ),
                    _WorkoutButton(
                      text: "pullups",
                      plan: model?.pullUpsPlan,
                    ),
                    _WorkoutButton(
                      text: "situps",
                      plan: model?.sitUpsPlan,
                    ),
                    _WorkoutButton(
                      text: "squats",
                      plan: model?.squatsPlan,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: progressIndicator,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WorkoutButton extends StatelessWidget {
  final String text;
  final List<Workout> plan;

  const _WorkoutButton({
    Key key,
    this.text,
    this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          var child = Center(child: Text(text));
          if (plan == null) return child;
          return InkWell(
            child: child,
            onTap: () {
              if (plan != null) {
                Navigator.of(context).push(
                  LevelSelectionScreen.route(context, plan),
                );
              }
            },
          );
        },
      ),
    );
  }
}
