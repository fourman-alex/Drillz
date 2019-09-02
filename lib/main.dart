import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pogo/audio.dart';
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
  ValueNotifier<Model> _modelValueNotifier = ValueNotifier(null);

  @override
  void initState() {
    //load notification sound
    audioPlayer.fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    audioPlayer.load("soft-bells.mp3").then((file) => debugPrint("$file loaded"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      primarySwatch: Colors.pink,
      accentColor: Colors.white,
    );
    theme = theme.copyWith(
      textTheme: theme.textTheme.merge(theme.typography.white),
      primaryTextTheme: theme.primaryTextTheme.merge(theme.typography.white),
      accentTextTheme: theme.accentTextTheme.merge(theme.typography.white),
    );

    return ChangeNotifierProvider.value(
      value: _modelValueNotifier,
      child: MaterialApp(
        theme: theme,
        home: WorkoutSelectionScreen(),
      ),
    );
  }
}
