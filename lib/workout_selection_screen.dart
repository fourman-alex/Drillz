import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pogo/level_selection_screen.dart';
import 'package:pogo/model.dart';
import 'package:pogo/repository.dart';
import 'package:provider/provider.dart';

class WorkoutSelectionScreen extends StatefulWidget {
  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "assets/athlete_background.png",
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.topLeft,
//              end: Alignment.bottomRight,
//              colors: [
//                Colors.white,
//                Colors.white30,
//              ],
//            ),
//          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
            filter: ImageFilter.blur(
              sigmaY: 5,
              sigmaX: 5,
            ),
          ),
        ),
        SafeArea(
          child: Consumer<ValueNotifier<Model>>(
            builder: (_, modelNotifier, __) {
              var model = modelNotifier.value;
              //create indicator
              Widget progressIndicator;
              if (model == null) {
                Repository.getModelAsync(context).then((model) {
                  modelNotifier.value = model;
                });
                progressIndicator = CircularProgressIndicator();
              } else
                progressIndicator = Container();

              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        child: FittedBox(
                          child: Text(
                            "PoGo",
                            style: TextStyle(fontFamily: "Righteous"),
                          ),
                        ),
                        type: MaterialType.transparency,
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    flex: 8,
                    child: GridView.count(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
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
                      shrinkWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: progressIndicator,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
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
    final borderRadius = BorderRadius.circular(15.0);

    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 4.0,
      child: Builder(
        builder: (context) {
          var child = Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 35.0, color: Colors.white),
            ),
          );
          if (plan == null) return child;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: child,
            onTap: () {
              if (plan != null) {
                Navigator.of(context)
                    .push(
                  LevelSelectionScreen.route(
                    context: context,
                    workouts: plan,
                    color: color,
                    fromRadius: borderRadius,
                  ),
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
