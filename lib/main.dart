import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/repository.dart';
import 'package:pogo/model.dart';
import 'package:pogo/workout_selection_screen.dart';
import 'package:provider/provider.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<WorkoutSelection> _modelValueNotifier = ValueNotifier(null);

  @override
  void initState() {
    //we need to load all workout data
    Repository.modelAsync.then((model) => _modelValueNotifier.value = model);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _modelValueNotifier,
      child: MaterialApp(
        color: primaryColor,
        home: WorkoutSelectionScreen(),
      ),
    );
  }
}
