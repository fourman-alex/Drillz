import 'package:flutter/foundation.dart';
import 'package:pogo/data.dart';
import 'package:pogo/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<WorkoutSelection> get modelAsync async {
  var pushUpPlan = List<Workout>();
  for (var level in pushUpsLevelSelection) {
    var id = level["id"];
    var dateAttempted = await _getWorkoutDate(Date.attempted, id);
    var dateCompleted = await _getWorkoutDate(Date.completed, id);
    pushUpPlan.add(Workout(id, level["steps"], dateAttempted, dateCompleted));
  }
  await Future.delayed(Duration(seconds: 3));
  return WorkoutSelection(pushUpPlan, pushUpPlan, pushUpPlan, pushUpPlan);
}

String _key(Date dateType, String id) => dateType.toString() + id;

Future<DateTime> _getWorkoutDate(Date dateType, String id) async {
  var prefs = await SharedPreferences.getInstance();
  var dateTimeString = prefs.getString(_key(dateType, id));
  if (dateTimeString != null) return DateTime.parse(dateTimeString);
  return null;
}

void setWorkoutDate(Date dateType, String id, DateTime completedDate) async {
  var prefs = await SharedPreferences.getInstance();
  var key = _key(dateType, id);
  var res = await prefs.setString(key, completedDate.toIso8601String());
  debugPrint("set $completedDate on key:$key is:$res");
}

enum Date { attempted, completed }
