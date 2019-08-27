import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  static Future<Model> getModelAsync(BuildContext context) async {
    List<Level> pushupLevels = List<Level>();
    List<Level> pullupLevels = List<Level>();
    List<Level> squatLevels = List<Level>();
    List<Level> situpLevels = List<Level>();
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/plan.json");
    List json = jsonDecode(data);
    for (int i = 0; i < json.length; i++) {
      var rawLevel = json[i];
      List rawSteps = rawLevel["steps"];
      List<ExerciseStep> steps = List<ExerciseStep>();
      steps.add(StartStep());
      for (var rawStep in rawSteps) {
        if (rawStep["type"] == "work") {
          steps.add(WorkStep(rawStep["reps"]));
        }
        if (rawStep["type"] == "rest") {
          steps.add(RestStep(rawStep["duration"]));
        }
      }
      steps.add(FinishStep());

      Future<Level> buildLevel(String id) async {
        return Level(
          id,
          steps,
          await _getWorkoutDate(Date.attempted, id),
          await _getWorkoutDate(Date.completed, id),
        );
      }

      var pushupsID = "pushups $i";
      pushupLevels.add(await buildLevel(pushupsID));
      var pullupsID = "pullups $i";
      pullupLevels.add(await buildLevel(pullupsID));
      var squatID = "squats $i";
      squatLevels.add(await buildLevel(squatID));
      var situpsID = "situps $i";
      situpLevels.add(await buildLevel(situpsID));
    }

    return Model(pushupLevels, pullupLevels, situpLevels, squatLevels);
  }

  static String _key(Date dateType, String id) => dateType.toString() + id;

  static Future<DateTime> _getWorkoutDate(Date dateType, String id) async {
    var prefs = await SharedPreferences.getInstance();
    var dateTimeString = prefs.getString(_key(dateType, id));
    if (dateTimeString != null) return DateTime.parse(dateTimeString);
    return null;
  }

  static void setWorkoutDate(
    Date dateType,
    String id,
    DateTime completedDate,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    var key = _key(dateType, id);
    var res = await prefs.setString(key, completedDate.toIso8601String());
    debugPrint("set $completedDate on key:$key is:$res");
  }
}

enum Date { attempted, completed }
