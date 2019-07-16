import 'package:shared_preferences/shared_preferences.dart';

Future<DateTime> getWorkoutAttempted(String id) async {
  var prefs = await SharedPreferences.getInstance();
  return DateTime.parse(prefs.getString("attempted:$id"));
}

void setWorkoutAttempted(String id, DateTime attemptedDate) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("attempted:$id", attemptedDate.toIso8601String());
}
