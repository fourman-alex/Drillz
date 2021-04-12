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

class WorkoutSelectionScreen extends StatefulWidget {
  const WorkoutSelectionScreen({Key? key}) : super(key: key);

  static const MethodChannel _platform = MethodChannel('drillz.com/rate');

  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Tween<double> _scaleTween = Tween(begin: 1.0, end: 0.8);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              builder: (context, child) => Transform.scale(
                scale: _scaleTween.evaluate(_controller),
                child: child,
              ),
              animation: _controller,
              child: _frontPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _frontPage() {
    return Consumer<Repository>(
      builder: (_, repository, __) {
        final workoutTypes =
            repository.model.plans.keys.toList(growable: false);

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              leading: _menuButtonBuilder(drawer: _drawerBuilder()),
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 64, right: 64),
                title: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Drillz',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontFamily: Consts.righteousFont,
                            shadows: <Shadow>[
                              Shadow(
                                  blurRadius: 25.0,
                                  color: Theme.of(context).primaryColorLight)
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: [
                for (int i = 0; i < workoutTypes.length; i++)
                  _WorkoutButton(
                    text: workoutTypes[i].name,
                    workoutType: workoutTypes[i],
                  )
              ],
            ),
          ],
        );
      },
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

  Widget _menuButtonBuilder({required Widget drawer}) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () async {
        _controller.forward();
        await showModalBottomSheet(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            return SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Theme(
                  data: ThemeData(primaryColor: Colors.white),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    child: drawer,
                  ),
                ),
              ),
            );
          },
        );
        _controller.reverse();
      },
    );
  }

  Widget _drawerBuilder() {
    return ListView(
      children: <Widget>[
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
                await (WorkoutSelectionScreen._platform
                    .invokeMethod('canRequestReview') as FutureOr<bool>)) {
              WorkoutSelectionScreen._platform
                  .invokeMethod<void>('requestReview');
            } else {
              WorkoutSelectionScreen._platform
                  .invokeMethod<void>('launchStore');
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
                colorScheme:
                    const ColorScheme.dark().copyWith(secondary: Colors.white),
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
    );
  }
}

class _WorkoutButton extends StatelessWidget {
  const _WorkoutButton({
    required this.text,
    required this.workoutType,
    Key? key,
  }) : super(key: key);

  final String text;
  final WorkoutType workoutType;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(15.0);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: workoutType.color,
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
                  fromColor: workoutType.color,
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
