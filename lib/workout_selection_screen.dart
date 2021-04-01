import 'dart:io';
import 'dart:ui';

import 'package:drillz/consts.dart';
import 'package:drillz/level_selection_screen.dart';
import 'package:drillz/model.dart';
import 'package:drillz/repository.dart';
import 'package:drillz/reset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const String _disclaimerText =
    'The information in this app is for general information purposes only. \nWhile a lot of thought and research has been put into the information provided, it does not substitue for personal professional advice.\n\nAny reliance you place on the information in this app is therefore strictly at your own risk.';

class WorkoutSelectionScreen extends StatelessWidget {
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
                        .display2
                        .copyWith(fontFamily: Consts.righteousFont),
                  ),
                  Text(
                    '100 challenge',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Reset'),
              onTap: () => _showResetDialog(context),
            ),
            ListTile(
              title: const Text('Rate'),
              onTap: () async {
                if (Platform.isIOS &&
                    await _platform.invokeMethod('canRequestReview')) {
                  _platform.invokeMethod<void>('requestReview');
                } else
                  _platform.invokeMethod<void>('launchStore');
              },
            ),
            ListTile(
              title: const Text('Disclaimer'),
              onTap: () {
                showDialog<SimpleDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('CLOSE'))
                        ],
                        contentPadding: const EdgeInsets.all(16.0),
                        content: SingleChildScrollView(
                          child: const Text(_disclaimerText),
                        ),
                      );
                    });
              },
            ),
            Theme(
              data: () {
                ThemeData theme = ThemeData.dark();
                theme = theme.copyWith(
                  buttonTheme: ButtonThemeData(
                      colorScheme:
                          ColorScheme.dark().copyWith(secondary: Colors.white)),
                );
                return theme;
              }(),
              child: AboutListTile(
                icon: null,
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
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).canvasColor,
            ),
            SafeArea(
              child: Consumer<Repository>(
                builder: (_, Repository repository, __) {
                  //create indicator
                  Widget progressIndicator;
                  if (repository.value == null) {
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                  ),
                                  onPressed: () {
                                    print('menu');
                                    Scaffold.of(context).openDrawer();
                                  },
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _WorkoutButton(
                                    text: Plan.getWorkoutTypeString(
                                            WorkoutType.pushups)
                                        .toUpperCase(),
                                    color: Colors.green,
                                    workoutType: WorkoutType.pushups,
                                  ),
                                  _WorkoutButton(
                                    text: Plan.getWorkoutTypeString(
                                            WorkoutType.pullups)
                                        .toUpperCase(),
                                    color: Colors.deepOrange,
                                    workoutType: WorkoutType.pullups,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _WorkoutButton(
                                    text: Plan.getWorkoutTypeString(
                                            WorkoutType.situps)
                                        .toUpperCase(),
                                    color: Colors.pink,
                                    workoutType: WorkoutType.situps,
                                  ),
                                  _WorkoutButton(
                                    text: Plan.getWorkoutTypeString(
                                            WorkoutType.squats)
                                        .toUpperCase(),
                                    color: Colors.indigo,
                                    workoutType: WorkoutType.squats,
                                  ),
                                ],
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
        ),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context) async {
    final Repository repository =
        Provider.of<Repository>(context, listen: false);
    final List<WorkoutType> workoutTypeList =
        await showDialog<List<WorkoutType>>(
      context: context,
      builder: (BuildContext context) {
        return ResetDialog();
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
    Key key,
    @required this.text,
    @required this.workoutType,
    @required this.color,
  }) : super(key: key);

  final String text;
  final WorkoutType workoutType;
  final MaterialColor color;

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
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: child,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
