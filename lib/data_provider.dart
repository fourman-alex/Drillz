import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _key(Date dateType, String id) => dateType.toString() + id;

Future<DateTime> getWorkoutDate(Date dateType, String id) async {
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
