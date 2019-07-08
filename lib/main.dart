import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pogo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Workout(),
    );
  }
}

enum StepType { work, rest }

class Step {
  final StepType stepType;
  final int amount;

  const Step(this.stepType, this.amount);
}

const List<Step> _steps = [
  Step(StepType.work, 5),
  Step(StepType.rest, 5),
  Step(StepType.work, 7),
  Step(StepType.rest, 5)
];

class Workout extends StatefulWidget {
  Workout({Key key}) : super(key: key);

  @override
  _WorkoutState createState() => _WorkoutState();
}

class CurrentStep extends ValueNotifier<int> {
  CurrentStep(int value) : super(value);
}

class StepSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentStep = Provider.of<CurrentStep>(context);
    Widget center;
    if (currentStep.value == null) {
      center = StartTile(
        onPressed: () => currentStep.value = 0,
      );
    } else if (currentStep.value >= _steps.length) {
      center = FinishTile();
    } else if (_steps[currentStep.value].stepType == StepType.rest) {
      center = RestTile(
        duration: _steps[currentStep.value].amount,
        onDone: () => currentStep.value++,
      );
    } else if (_steps[currentStep.value].stepType == StepType.work) {
      center = WorkTile(
        amount: _steps[currentStep.value].amount,
        onPressed: () => currentStep.value++,
      );
    }

    if (center == null) throw Error();

    return AnimatedSwitcher(
      child: center,
      duration: Duration(milliseconds: 500),
    );
  }
}

class _WorkoutState extends State<Workout> {
  CurrentStep _currentActiveStep;

  @override
  void initState() {
    super.initState();
    _currentActiveStep = CurrentStep(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: _currentActiveStep,
        child: Stack(
          children: <Widget>[
            StepSwitcher(),
            WorkoutStepsBar(),
          ],
        ),
      ),
    );
  }
}

class WorkoutStepsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var workoutSteps = List<Widget>();
    for (var i = 0; i < _steps.length; ++i) {
      var step = _steps[i];
      if (step.stepType == StepType.work) {
        workoutSteps.add(RaisedButton(
          child: Text("Do ${step.amount} pushups"),
          onPressed: () {
            Provider.of<CurrentStep>(context).value = i;
          },
        ));
      } else {
        workoutSteps.add(RaisedButton(
          child: Text("Rest ${step.amount} seconds"),
          onPressed: () {
            Provider.of<CurrentStep>(context).value = i;
          },
        ));
      }
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: workoutSteps,
      ),
    );
  }
}

class StartTile extends StatelessWidget {
  final VoidCallback _onPressed;

  StartTile({@required VoidCallback onPressed}) : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.expand(
      child: FittedBox(
        child: GestureDetector(
          onTap: _onPressed,
          child: Text(
            "Start",
          ),
        ),
      ),
    ));
  }
}

class FinishTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.expand(
      child: FittedBox(
        child: Text(
          "Done!",
        ),
      ),
    ));
  }
}

class WorkTile extends StatelessWidget {
  final int _amount;
  final VoidCallback _onPressed;

  WorkTile({@required int amount, @required VoidCallback onPressed})
      : _onPressed = onPressed,
        _amount = amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FittedBox(
          child: Text(
            "Do $_amount pushups!",
          ),
        ),
        RaisedButton(
          child: Text("done"),
          onPressed: _onPressed,
        ),
      ],
    );
  }
}

class RestTile extends StatefulWidget {
  final int duration;
  final VoidCallback _onDone;

  @override
  _RestTileState createState() => _RestTileState();

  RestTile({Key key, @required this.duration, @required VoidCallback onDone})
      : _onDone = onDone,
        super(key: key);
}

class _RestTileState extends State<RestTile>
    with AutomaticKeepAliveClientMixin<RestTile> {
  double _progressBarHeight = 0;
  int _timerString;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timerString = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                curve: Curves.elasticOut,
                duration: Duration(milliseconds: 750),
                color: Colors.green,
                height: _progressBarHeight,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Rest",
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    "${_timerString.toString().padLeft(2, '0')}:00",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTap() {
    //makes tap do nothing after timer has started
    if (_timer != null && _timer.isActive) return;

    var duration = _timerString;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(timer.tick);
      if (timer.tick > duration) {
        timer.cancel();
        widget._onDone();
      } else {
        setState(() {
          _progressBarHeight = context.size.height * (timer.tick / duration);
          _timerString = (duration - timer.tick);
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
