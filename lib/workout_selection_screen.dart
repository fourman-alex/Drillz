import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'consts.dart';
import 'edit_workouts_page.dart';
import 'level_selection_screen.dart';
import 'model.dart';
import 'repository.dart';
import 'reset_dialog.dart';

const String _disclaimerText =
    'The information in this app is for general information purposes only. '
    '\nWhile a lot of thought and research has been put into the information '
    'provided, it does not substitue for personal professional advice.\n\nAny '
    'reliance you place on the information in this app is therefore strictly '
    'at your own risk.';

class WorkoutSelectionScreen extends StatelessWidget {
  const WorkoutSelectionScreen({Key? key}) : super(key: key);

  static const MethodChannel _platform = MethodChannel('drillz.com/rate');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Drillz',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontFamily: Consts.righteousFont),
                  ),
                  Text(
                    '100 challenge',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Edit Workouts'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditWorkoutsPage(),
              )),
            ),
            ListTile(
              title: const Text('Reset'),
              onTap: () => _showResetDialog(context),
            ),
            ListTile(
              title: const Text('Rate'),
              onTap: () async {
                if (Platform.isIOS &&
                    await (_platform.invokeMethod('canRequestReview')
                        as FutureOr<bool>)) {
                  _platform.invokeMethod<void>('requestReview');
                } else {
                  _platform.invokeMethod<void>('launchStore');
                }
              },
            ),
            ListTile(
              title: const Text('Disclaimer'),
              onTap: () {
                showDialog<SimpleDialog>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('CLOSE'))
                        ],
                        contentPadding: const EdgeInsets.all(16.0),
                        content: const SingleChildScrollView(
                          child: Text(_disclaimerText),
                        ),
                      );
                    });
              },
            ),
            Theme(
              data: () {
                final ThemeData theme = ThemeData.dark().copyWith(
                  buttonTheme: ButtonThemeData(
                    colorScheme: const ColorScheme.dark()
                        .copyWith(secondary: Colors.white),
                  ),
                );
                return theme;
              }(),
              child: AboutListTile(
                applicationName: Consts.drillz,
                applicationLegalese: 'Copyright © Alex Fourman 2019',
                applicationIcon: const Image(
                  image: AssetImage('assets/icon.png'),
                  width: 70,
                  height: 70,
                ),
                aboutBoxChildren: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      Consts.contactEmail,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Consumer<Repository>(
          builder: (_, repository, __) {
            final workoutTypes =
                repository.model.plans.keys.toList(growable: false);

            //create indicator
            Widget progressIndicator;
            if (repository.model == Model.empty()) {
              progressIndicator = const CircularProgressIndicator();
            } else {
              progressIndicator = const SizedBox(
                height: 0,
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Material(
                            type: MaterialType.transparency,
                            child: FittedBox(
                              child: Text(
                                'Drillz',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
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
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: IconButton(
                            icon: const Icon(
                              Icons.menu,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      for (int i = 0; i < workoutTypes.length; i++)
                        _WorkoutButton(
                            text: workoutTypes[i].name,
                            workoutType: workoutTypes[i],
                            color: workoutColors[i])
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: progressIndicator,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context) async {
    final Repository repository =
        Provider.of<Repository>(context, listen: false);
    final List<WorkoutType>? workoutTypeList =
        await showDialog<List<WorkoutType>>(
      context: context,
      builder: (context) {
        return const ResetDialog();
      },
    );
    if (workoutTypeList != null) {
      await repository.resetWorkoutType(workoutTypeList);
      Navigator.of(context).pop();
    }
  }
}

class _WorkoutButton extends StatelessWidget {
  const _WorkoutButton({
    required this.text,
    required this.workoutType,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final WorkoutType workoutType;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(15.0);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: Builder(
        builder: (context) {
          final Center child = Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                //makes sure that the font size fills the container
                //AND is the same for all the buttons
                final double fontSize = constraints.biggest.width / 5.5;
                return Text(
                  text,
                  style: Theme.of(context).primaryTextTheme.bodyText2!.copyWith(
                        fontSize: fontSize,
                        fontFamily: Consts.righteousFont,
                      ),
                );
              },
            ),
          );
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).push(
                LevelSelectionScreen.route(
                  title: text,
                  context: context,
                  workoutType: workoutType,
                  fromColor: color,
                  toColor: Theme.of(context).canvasColor,
                  fromRadius: borderRadius,
                ),
              );
            },
            child: child,
          );
        },
      ),
    );
  }
}
