import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
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
            "assets/background.jpg",
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            child: Container(
              color: Colors.black.withOpacity(0.5),
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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
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
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  fontFamily: Consts.righteousFont,
                                  shadows: <Shadow>[
                                    Shadow(
                                        blurRadius: 25.0,
                                        color:
                                            Theme.of(context).primaryColorLight)
                                  ]),
                            ),
                          ),
                          type: MaterialType.transparency,
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                _WorkoutButton(
                                  text: "PUSHUPS",
                                  color: Colors.green,
                                  plan: model?.pushUpsPlan,
                                ),
                                _WorkoutButton(
                                  text: "PULLUPS",
                                  color: Colors.deepOrange,
                                  plan: model?.pullUpsPlan,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                _WorkoutButton(
                                  text: "SITUPS",
                                  color: Theme.of(context).primaryColor,
                                  plan: model?.sitUpsPlan,
                                ),
                                _WorkoutButton(
                                  text: "SQUATS",
                                  plan: model?.squatsPlan,
                                  color: Colors.indigo,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
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
                ),
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

    return Flexible(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Builder(
            builder: (context) {
              final child = Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    //makes sure that the font size fills the container
                    //AND is the same for all the buttons
                    final fontSize = constraints.biggest.width/5;
                    return Text(
                      text,
                      style: Theme.of(context).primaryTextTheme.body1.copyWith(
                            fontSize: fontSize,
                            fontFamily: Consts.righteousFont,
                          ),
                    );
                  },
                ),
              );
              if (plan == null) return child;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: child,
                onTap: () {
                  if (plan != null) {
                    //find all completed and the first uncompleted level
                    final levels = List<Level>();
                    final lastCompletedIndex = plan.lastIndexWhere((workout) {
                      return workout.dateCompleted != null;
                    });
                    if (lastCompletedIndex != -1) {
                      levels.addAll(plan.getRange(0, lastCompletedIndex + 1));
                    }

                    final currentWorkout =
                        (lastCompletedIndex + 1 < plan.length)
                            ? plan[lastCompletedIndex + 1]
                            : null;

                    Navigator.of(context).push(
                      LevelSelectionScreen.route(
                        title: text,
                        context: context,
                        workouts: levels,
                        currentWorkout: currentWorkout,
                        fromColor: color,
                        toColor: Colors.grey[850],
                        fromRadius: borderRadius,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
