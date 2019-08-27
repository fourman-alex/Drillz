import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pogo/audio.dart';
import 'package:pogo/model.dart';
import 'package:pogo/repository.dart';
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
  ValueNotifier<Model> _modelValueNotifier = ValueNotifier(null);

  @override
  void initState() {
    //load notification sound
    player.fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    player.load("soft-bells.mp3").then((file) => debugPrint("$file loaded"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _modelValueNotifier,
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: WorkoutSelectionScreen(),
      ),
    );
  }
}
