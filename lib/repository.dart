import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:drillz/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  static Future<Model> getModelAsync(BuildContext context) async {
    final List<Level> pushupLevels = <Level>[];
    final List<Level> pullupLevels = <Level>[];
    final List<Level> squatLevels = <Level>[];
    final List<Level> situpLevels = <Level>[];
    final String data =
        await DefaultAssetBundle.of(context).loadString('assets/plan.json');
    final List<dynamic> json = jsonDecode(data);
    for (int i = 0; i < json.length; i++) {
      final Map<String, dynamic> rawLevel = json[i];
      final List<dynamic> rawSteps = rawLevel['steps'];
      final List<ExerciseStep> steps = <ExerciseStep>[];
      steps.add(const StartStep());
      for (Map<String, dynamic> rawStep in rawSteps) {
        if (rawStep['type'] == 'work') {
          steps.add(WorkStep(rawStep['reps']));
        }
        if (rawStep['type'] == 'rest') {
          steps.add(RestStep(rawStep['duration']));
        }
      }
      steps.add(const FinishStep());

      Future<Level> buildLevel(String id) async {
        return Level(
          id,
          steps,
          await _getWorkoutDate(Date.attempted, id),
          await _getWorkoutDate(Date.completed, id),
        );
      }

      final String pushupsID = 'pushups $i';
      pushupLevels.add(await buildLevel(pushupsID));
      final String pullupsID = 'pullups $i';
      pullupLevels.add(await buildLevel(pullupsID));
      final String squatID = 'squats $i';
      squatLevels.add(await buildLevel(squatID));
      final String situpsID = 'situps $i';
      situpLevels.add(await buildLevel(situpsID));
    }

    return Model(pushupLevels, pullupLevels, situpLevels, squatLevels);
  }

  static String _key(Date dateType, String id) => dateType.toString() + id;

  static Future<DateTime> _getWorkoutDate(Date dateType, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dateTimeString = prefs.getString(_key(dateType, id));
    if (dateTimeString != null) {
      return DateTime.parse(dateTimeString);
    }
    return null;
  }

  static Future<void> setWorkoutDate(
    Date dateType,
    String id,
    DateTime completedDate,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = _key(dateType, id);
    final bool res = await prefs.setString(key, completedDate.toIso8601String());
    debugPrint('set $completedDate on key:$key is:$res');
  }
}

enum Date { attempted, completed }
