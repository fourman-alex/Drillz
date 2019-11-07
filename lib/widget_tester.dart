import 'package:drillz/calibration_banner.dart';
import 'package:drillz/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//todo add keys to widget constructors

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            CalibrationBanner(
              onCalibrate: (int value) {},
            ),
            Container(
              height: 50,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}


final List<ExerciseStep> _steps = <ExerciseStep>[
  StartStep(),
  WorkStep(16),
  RestStep(60),
  WorkStep(13),
  RestStep(60),
  WorkStep(11),
  RestStep(60),
  WorkStep(10),
  RestStep(60),
  WorkStep(9),
  RestStep(60),
  WorkStep(8),
  FinishStep(),
];

final Level _level = Level('level id', _steps, null, null);
