import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts.dart';
import 'edit_workouts_page.dart';
import 'level_selection_screen.dart';
import 'model.dart';
import 'rate.dart';
import 'repository.dart';
import 'reset_dialog.dart';
import 'theme.dart';

const String _disclaimerText =
    'The information in this app is for general information purposes only. '
    '\nWhile a lot of thought and research has been put into the information '
    'provided, it does not substitue for personal professional advice.\n\nAny '
    'reliance you place on the information in this app is therefore strictly '
    'at your own risk.';

class WorkoutSelectionScreen extends StatefulWidget {
  const WorkoutSelectionScreen({Key? key}) : super(key: key);

  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Tween<double> _scaleTween = Tween(begin: 1.0, end: 0.8);
  late Animation<double> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _drawerAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedBuilder(
        builder: (context, child) => Transform.scale(
          scale: _scaleTween.evaluate(_drawerAnimation),
          child: child,
        ),
        animation: _controller,
        child: _frontPage(),
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
              backgroundColor: Theme.of(context).colorScheme.background,
              leading: _menuButtonBuilder(drawer: _drawerBuilder()),
              titleTextStyle: TextStyle(
                fontFamily: Consts.righteousFont,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 30,
              ),
              title: const Text(
                '${Consts.drillz}™',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.md),
              sliver: SliverGrid.count(
                crossAxisSpacing: Insets.md,
                mainAxisSpacing: Insets.md,
                crossAxisCount: 2,
                children: [
                  for (int i = 0; i < workoutTypes.length; i++)
                    _WorkoutButton(
                      text: workoutTypes[i].name,
                      workoutType: workoutTypes[i],
                    )
                ],
              ),
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
      icon: Icon(
        Icons.menu,
        color: Theme.of(context).colorScheme.onSurface,
      ),
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
                child: Material(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(15.0),
                  child: drawer,
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
    final onSecondaryContainer = Theme.of(context).colorScheme.surface;
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            'Edit Workouts',
            style: TextStyle(color: onSecondaryContainer),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const EditWorkoutsPage(),
          )),
        ),
        ListTile(
          title: Text(
            'Reset',
            style: TextStyle(color: onSecondaryContainer),
          ),
          onTap: () => _showResetDialog(context),
        ),
        ListTile(
          title: Text(
            'Rate',
            style: TextStyle(color: onSecondaryContainer),
          ),
          onTap: () async {
            rateMyApp.showRateDialog(
              context,
              title: 'Rate Drillz',
              // The dialog title.
              message: 'We would love to hear your opinion on the app!',
              rateButton: 'RATE',
              // The dialog "rate" button text.
              noButton: 'NO THANKS',
              // The dialog "no" button text.
              laterButton: 'MAYBE LATER',
              // The dialog "later" button text.
              ignoreNativeDialog: false,
            ); // Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            'Disclaimer',
            style: TextStyle(
              color: onSecondaryContainer,
            ),
          ),
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
        AboutListTile(
          applicationName: Consts.drillz,
          applicationLegalese: 'Copyright © Alex Fourman 2019',
          applicationIcon: const Image(
            height: 50,
            width: 50,
            image: AssetImage('assets/icon.png'),
          ),
          child: Text(
            'About',
            style: TextStyle(
              color: onSecondaryContainer,
            ),
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
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
