import 'package:flutter/foundation.dart' as Foundation;
import 'package:shared_preferences/shared_preferences.dart';

const String _attemptedPrefKey = "attempted:";
const String _completedPrefKey = "completed:";

Future<DateTime> getWorkoutAttempted(String id) async {
  var prefs = await SharedPreferences.getInstance();
  return DateTime.parse(prefs.getString(_attemptedPrefKey + id));
}

void setWorkoutAttempted(String id, DateTime attemptedDate) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(_attemptedPrefKey + id, attemptedDate.toIso8601String());
}

void setWorkoutCompleted(String id, DateTime completedDate) async {
  var prefs = await SharedPreferences.getInstance();
  var res = await prefs.setString(
      _completedPrefKey + id, completedDate.toIso8601String());
  if (Foundation.kDebugMode)
    print("set $completedDate on key: $_completedPrefKey + $id is:$res");
}
