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
            // TODO(alex): move to consts
            'assets/background.jpg',
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
            builder: (_, ValueNotifier<Model> modelNotifier, __) {
              final Model model = modelNotifier.value;
              //create indicator
              Widget progressIndicator;
              if (model == null) {
                Repository.getModelAsync(context).then((Model model) {
                  modelNotifier.value = model;
                });
                progressIndicator = const CircularProgressIndicator();
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
                              'PoGo',
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
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                _WorkoutButton(
                                  text: 'PUSHUPS',
                                  color: Colors.green,
                                  plan: model?.pushUpsPlan,
                                ),
                                _WorkoutButton(
                                  text: 'PULLUPS',
                                  color: Colors.deepOrange,
                                  plan: model?.pullUpsPlan,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                _WorkoutButton(
                                  text: 'SITUPS',
                                  color: Theme.of(context).primaryColor,
                                  plan: model?.sitUpsPlan,
                                ),
                                _WorkoutButton(
                                  text: 'SQUATS',
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
                          duration: const Duration(milliseconds: 250),
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
  const _WorkoutButton({
    Key key,
    this.text,
    this.plan,
    this.color,
  }) : super(key: key);

  final String text;
  final List<Level> plan;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(15.0);

    return Flexible(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Builder(
            builder: (BuildContext context) {
              final Center child = Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    //makes sure that the font size fills the container
                    //AND is the same for all the buttons
                    final double fontSize = constraints.biggest.width / 5;
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
              if (plan == null) {
                return child;
              }

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: child,
                onTap: () {
                  if (plan != null) {
                    //find all completed and the first uncompleted level
                    final List<Level> levels = <Level>[];
                    final int lastCompletedIndex =
                        plan.lastIndexWhere((Level workout) {
                      return workout.dateCompleted != null;
                    });
                    if (lastCompletedIndex != -1) {
                      levels.addAll(plan.getRange(0, lastCompletedIndex + 1));
                    }

                    final Level currentWorkout =
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
