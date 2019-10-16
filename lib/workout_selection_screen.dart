import 'dart:ui';

import 'package:drillz/consts.dart';
import 'package:drillz/level_selection_screen.dart';
import 'package:drillz/model.dart';
import 'package:drillz/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).canvasColor,
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

              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            child: IconButton(
                              icon: Icon(
                                Icons.menu,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              child: FittedBox(
                                child: Text(
                                  'Drillz',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                          fontFamily: Consts.righteousFont,
                                          shadows: <Shadow>[
                                        Shadow(
                                            blurRadius: 25.0,
                                            color: Theme.of(context)
                                                .primaryColorLight)
                                      ]),
                                ),
                              ),
                              type: MaterialType.transparency,
                            ),
                          ),
                        ),
                      ],
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
                                color: Colors.pink,
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
                    final double fontSize = constraints.biggest.width / 5.5;
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
                        toColor: Theme.of(context).canvasColor,
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
