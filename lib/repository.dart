import 'package:flutter/foundation.dart';
import 'package:pogo/data/pullups.dart';
import 'package:pogo/data/pushups.dart';
import 'package:pogo/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  ///get all plans asynchronously
  static Future<WorkoutSelection> get modelAsync async {
    var pushUpPlan = List<Workout>();
    for (var level in pushUpsData) {
      var id = level["id"];
      var dateAttempted = await _getWorkoutDate(Date.attempted, id);
      var dateCompleted = await _getWorkoutDate(Date.completed, id);
      pushUpPlan.add(Workout(id, level["steps"], dateAttempted, dateCompleted));
    }

    var pullupsPlan = List<Workout>();
    for (var level in pullupsData) {
      var id = level["id"];
      var dateAttempted = await _getWorkoutDate(Date.attempted, id);
      var dateCompleted = await _getWorkoutDate(Date.completed, id);
      pullupsPlan.add(Workout(id, level["steps"], dateAttempted, dateCompleted));
    }

    //todo: actually add situps, squats data
    return WorkoutSelection(pushUpPlan, pullupsPlan, pushUpPlan, pushUpPlan);
  }

  static String _key(Date dateType, String id) => dateType.toString() + id;

  static Future<DateTime> _getWorkoutDate(Date dateType, String id) async {
    var prefs = await SharedPreferences.getInstance();
    var dateTimeString = prefs.getString(_key(dateType, id));
    if (dateTimeString != null) return DateTime.parse(dateTimeString);
    return null;
  }

  static void setWorkoutDate(Date dateType, String id, DateTime completedDate) async {
    var prefs = await SharedPreferences.getInstance();
    var key = _key(dateType, id);
    var res = await prefs.setString(key, completedDate.toIso8601String());
    debugPrint("set $completedDate on key:$key is:$res");
  }


}

enum Date { attempted, completed }