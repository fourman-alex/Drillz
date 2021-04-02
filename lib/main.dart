import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio.dart';
import 'repository.dart';
import 'workout_selection_screen.dart';
//todo add keys to widget constructors

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //load notification sound
    audioPlayer.fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    audioPlayer
        .load('soft-bells.mp3')
        .then((file) => debugPrint('$file loaded'));
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
      brightness: Brightness.dark,
      primaryColor: Colors.grey[850],
      accentColor: Colors.white,
      canvasColor: Colors.grey[850],
      iconTheme: const IconThemeData(color: Colors.white),
    );
    theme = theme.copyWith(
      buttonTheme: ButtonThemeData(
          colorScheme:
              const ColorScheme.dark().copyWith(secondary: Colors.white)),
      textTheme: theme.textTheme.merge(theme.typography.white),
      primaryTextTheme: theme.primaryTextTheme.merge(theme.typography.white),
      accentTextTheme: theme.accentTextTheme.merge(theme.typography.white),
    );

    return ChangeNotifierProvider<Repository>(
      create: (context) => Repository(context),
      child: MaterialApp(
        theme: theme,
        home: const WorkoutSelectionScreen(),
        navigatorObservers: <NavigatorObserver>[popAnimationObserver],
      ),
    );
  }
}

final _PopAnimationObserver popAnimationObserver = _PopAnimationObserver();

///Use [isAnimating] to query whether a pop animation is in progress.
///
///This is used to disable rapid back press during the somewhat slow pop
///animation
class _PopAnimationObserver extends NavigatorObserver {
  bool _isAnimating = false;

  bool get isAnimating => _isAnimating;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is ModalRoute) {
      _isAnimating = true;
      debugPrint('isAnimating: TRUE');
      route.completed.then((_) {
        debugPrint('isAnimating: FALSE');
        return _isAnimating = false;
      });
    }
  }
}
