import 'dart:async';

import 'package:flutter/material.dart';

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
  Step(StepType.rest, 60),
  Step(StepType.work, 7),
  Step(StepType.rest, 30)
];

class Workout extends StatefulWidget {
  Workout({Key key}) : super(key: key);

  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  bool isStarted = false;
  int _currentActiveStep = 0;

  @override
  Widget build(BuildContext context) {
    Widget center;
    if (_steps[_currentActiveStep].stepType == StepType.rest) {
      center = RestTile(
        duration: _steps[_currentActiveStep].amount,
      );
    } else {
      center = Container(
        child: Text("do some work!"),
      );
    }

    var workoutSteps = List<Widget>();
    for (var i = 0; i < _steps.length; ++i) {
      var step = _steps[i];
      if (step.stepType == StepType.work) {
        workoutSteps.add(RaisedButton(
          child: Text("Do ${step.amount} pushups"),
          onPressed: () {
            setState(() {
              _currentActiveStep = i;
            });
          },
        ));
      } else {
        workoutSteps.add(RaisedButton(
          child: Text("Rest ${step.amount} seconds"),
          onPressed: () {
            setState(() {
              _currentActiveStep = i;
            });
          },
        ));
      }
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            child: center,
            duration: Duration(milliseconds: 700),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: workoutSteps,
            ),
          ),
        ],
      ),
    );
  }
}

class RestTile extends StatefulWidget {
  final int duration;

  @override
  _RestTileState createState() => _RestTileState();

  RestTile({Key key, this.duration}) : super(key: key);
}

class _RestTileState extends State<RestTile>
    with AutomaticKeepAliveClientMixin<RestTile> {
  double _height = 0;
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
                height: _height,
              ),
            ),
            Align(
              child: Text(
                "${_timerString.toString().padLeft(2, '0')}:00",
                textScaleFactor: 7,
              ),
              alignment: Alignment.center,
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
    var duration = _timerString;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(timer.tick);
      if (timer.tick > duration) {
        timer.cancel();
        updateKeepAlive();
      } else {
        setState(() {
          _height = context.size.height * (timer.tick / duration);
          _timerString = (duration - timer.tick);
        });
      }
      updateKeepAlive();
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => _timer?.isActive ?? false;
}
