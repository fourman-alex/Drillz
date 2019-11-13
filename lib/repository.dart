import 'dart:convert';
import 'dart:math';

import 'package:drillz/consts.dart';
import 'package:drillz/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository extends ValueNotifier<Model> {
  factory Repository(BuildContext context) {
    _repository ??= Repository._internal(context);
    return _repository;
  }

  Repository._internal(BuildContext context) : super(null) {
    _getModelFromContext(context).then((Model model) {
      value = model;
    });
  }

  static Repository _repository;

  List<dynamic> _staticJsonData;

  ///Get the model from scratch. Will load the json and then additional shared
  ///pref data. Should only be called once per app's lifecycle.
  ///
  ///See also:
  /// * [_getModelFromJson] to load everything but the json
  Future<Model> _getModelFromContext(BuildContext context) async {
    final String jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/plan.json');
    _staticJsonData = jsonDecode(jsonString);

    return _getModelFromJson(_staticJsonData);
  }

  Future<Model> _getModelFromJson(List<dynamic> json) async {
    final List<Level> pushupLevels = <Level>[];
    final List<Level> pullupLevels = <Level>[];
    final List<Level> squatLevels = <Level>[];
    final List<Level> situpLevels = <Level>[];
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

    return Model(
      <WorkoutType, Plan>{
        WorkoutType.pushups: Plan(
          WorkoutType.pushups,
          pushupLevels,
          await _getIsCalibrated(WorkoutType.pushups),
        ),
        WorkoutType.pullups: Plan(
          WorkoutType.pullups,
          pullupLevels,
          await _getIsCalibrated(WorkoutType.pullups),
        ),
        WorkoutType.situps: Plan(
          WorkoutType.situps,
          situpLevels,
          await _getIsCalibrated(WorkoutType.situps),
        ),
        WorkoutType.squats: Plan(
          WorkoutType.squats,
          squatLevels,
          await _getIsCalibrated(WorkoutType.squats),
        ),
      },
    );
  }

  String _key(Date dateType, String id) => dateType.toString() + id;

  Future<DateTime> _getWorkoutDate(Date dateType, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dateTimeString = prefs.getString(_key(dateType, id));
    if (dateTimeString != null) {
      return DateTime.parse(dateTimeString);
    }
    return null;
  }

  ///Set workout date and reloads the model so that the changes take effect on
  ///listeners
  Future<void> setWorkoutDate(
    Date dateType,
    String id,
    DateTime completedDate,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = _key(dateType, id);
    final bool res =
        await prefs.setString(key, completedDate.toIso8601String());
    debugPrint('set $completedDate on key:$key is:$res');

    _reloadLevel(id);
  }

  Future<void> calibratePlan(
      WorkoutType workoutType, int calibrationValue) async {
    final Plan plan = value.plans[workoutType];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCalibrated:$workoutType', true);

    if (calibrationValue != null) {
      final int total =
          min(100, max(5, (calibrationValue * kCalibrationMultiplier).toInt()));
      final String workoutID =
          plan.levels.lastWhere((Level level) => level.total == total).id;
      await setWorkoutDate(Date.completed, workoutID, DateTime.now());
      //not calling to any reload method because [setWorkoutDate] does that internally.
      // this might have a better solution
    } else {
      await _reloadModel();
    }
  }

  Future<void> resetWorkoutType(List<WorkoutType> workoutTypeList) async {
    if(workoutTypeList == null || workoutTypeList.isEmpty)
      return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (WorkoutType workoutType in workoutTypeList){
      final Plan plan = value.getPlan(workoutType);
      for (Level level in plan.levels){
        await prefs.remove(_key(Date.completed, level.id));
        await prefs.remove(_key(Date.attempted, level.id));
      }
      await prefs.remove('isCalibrated:$workoutType');
    }
    await _reloadModel();
  }

  ///Updates the [value] (the model) by reloading everything but the json.
  ///
  ///This method assumes [_staticJsonData] is not null
  Future<void> _reloadModel() async {
    value = await _getModelFromJson(_staticJsonData);
  }

  Future<void> _reloadLevel(String id) async {
    for (Plan plan in value.plans.values) {
      final Level level = plan.levels
          .firstWhere((Level level) => level.id == id, orElse: () => null);
      if (level != null) {
        level.dateCompleted = await _getWorkoutDate(Date.completed, id);
        level.dateAttempted = await _getWorkoutDate(Date.attempted, id);
        notifyListeners();
        break;
      }
    }
  }

  Future<bool> _getIsCalibrated(WorkoutType workoutType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isCalibrated:$workoutType') ?? false;
  }
}

enum Date { attempted, completed }
