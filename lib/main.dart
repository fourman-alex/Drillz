import 'package:audioplayers/audioplayers.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio.dart';
import 'rate.dart';
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
    audioPlayer.setSource(AssetSource('soft-bells.mp3'));
    //load the stupid shared pref
    SharedPreferences.getInstance();
    //lock screen orientation
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();
    rateMyApp.init();
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF6200FF);
    return ChangeNotifierProvider<Repository>(
      create: Repository.new,
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => MaterialApp(
          theme: ThemeData(
            colorScheme: lightDynamic?.harmonized() ??
                ColorScheme.fromSeed(
                  seedColor: brandColor,

                ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic?.harmonized() ??
                ColorScheme.fromSeed(
                  seedColor: brandColor,
                  brightness: Brightness.dark,
                ),
          ),
          home: const WorkoutSelectionScreen(),
          navigatorObservers: <NavigatorObserver>[popAnimationObserver],
        ),
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
