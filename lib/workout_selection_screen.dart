import 'package:flutter/material.dart';
import 'package:pogo/level_selection_screen.dart';
import 'package:pogo/model.dart';
import 'package:provider/provider.dart';

class WorkoutSelectionScreen extends StatefulWidget {
  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<ValueNotifier<Model>>(
        builder: (_, modelNotifier, __) {
          var model = modelNotifier.value;
          //create indicator
          Widget progressIndicator;
          if (model == null) {
            progressIndicator = CircularProgressIndicator();
          } else
            progressIndicator = Container();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: <Widget>[
                  _WorkoutButton(
                    text: "PUSHUPS",
                    color: Colors.lightBlue,
                    plan: model?.pushUpsPlan,
                  ),
                  _WorkoutButton(
                    text: "PULLUPS",
                    color: Colors.deepPurple,
                    plan: model?.pullUpsPlan,
                  ),
                  _WorkoutButton(
                    text: "SITUPS",
                    color: Colors.lightGreen,
                    plan: model?.sitUpsPlan,
                  ),
                  _WorkoutButton(
                    text: "SQUATS",
                    color: Colors.amber,
                    plan: model?.squatsPlan,
                  ),
                ],
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
  final List<Level> plan;
  final Color color;

  const _WorkoutButton({
    Key key,
    this.text,
    this.plan,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Builder(
        builder: (context) {
          var child = Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 35.0),
            ),
          );
          if (plan == null) return child;
          return InkWell(
            child: child,
            onTap: () {
              if (plan != null) {
                Navigator.of(context)
                    .push(
                  LevelSelectionScreen.route(context, plan, color),
                )
                    .then((returnValue) {
                  debugPrint("LevelSelectionScreen popped");
                });
              }
            },
          );
        },
      ),
    );
  }
}
