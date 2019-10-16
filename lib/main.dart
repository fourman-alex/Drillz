import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drillz/audio.dart';
import 'package:drillz/model.dart';
import 'package:drillz/workout_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<Model> _modelValueNotifier = ValueNotifier<Model>(null);

  @override
  void initState() {
    //load notification sound
    audioPlayer.fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    audioPlayer
        .load('soft-bells.mp3')
        .then((File file) => debugPrint('$file loaded'));
    //load the stupid shared pref
    SharedPreferences.getInstance();
    //lock screen orientation
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primarySwatch: Colors.pink,
      accentColor: Colors.white,
      canvasColor: Colors.grey[850],
      iconTheme: IconThemeData(color: Colors.white),
    );
    theme = theme.copyWith(
      textTheme: theme.textTheme.merge(theme.typography.white),
      primaryTextTheme: theme.primaryTextTheme.merge(theme.typography.white),
      accentTextTheme: theme.accentTextTheme.merge(theme.typography.white),
    );

    return ChangeNotifierProvider<ValueNotifier<Model>>.value(
      value: _modelValueNotifier,
      child: MaterialApp(
        theme: theme,
        home: WorkoutSelectionScreen(),
        navigatorObservers: <NavigatorObserver>[popAnimationObserver],
      ),
    );
  }
}

final _PopAnimationObserver popAnimationObserver = _PopAnimationObserver();

///Use [isAnimating] to query whether a pop animation is in progress.
///
///This is used to disable rapid back press during the somewhat slow pop animation
class _PopAnimationObserver extends NavigatorObserver {
  bool _isAnimating;

  bool get isAnimating => _isAnimating ?? false;

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route is ModalRoute) {
      _isAnimating = true;
      debugPrint('isAnimating: TRUE');
      route.completed.then((dynamic _) {
        debugPrint('isAnimating: FALSE');
        return _isAnimating = false;
      });
    }
  }
}
