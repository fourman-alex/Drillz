import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consts.dart';
import 'model.dart';

const _workoutTypesKey = '_workoutTypesKey';

class Repository extends ChangeNotifier {
  factory Repository(BuildContext context) {
    return _repository ??= Repository._internal(context);
  }

  Repository._internal(BuildContext context) {
    Future(() async {
      model = await _getModelFromContext(context);
      notifyListeners();
    });
  }

  static Repository? _repository;

  List<dynamic>? _staticJsonData;
  Model model = Model.empty();

  ///Get the model from scratch. Will load the json and then additional shared
  ///pref data. Should only be called once per app's lifecycle.
  ///
  ///See also:
  /// * [_getModelFromJson] to load everything but the json
  Future<Model> _getModelFromContext(BuildContext context) async {
    final String jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/plan.json');
    _staticJsonData = jsonDecode(jsonString);

    final workoutTypes = await _loadWorkoutTypes() ??
        const [
          WorkoutType(id: 'pushups', name: 'Pushups'),
          WorkoutType(id: 'pullups', name: 'Pullups'),
          WorkoutType(id: 'squats', name: 'Squats'),
          WorkoutType(id: 'situps', name: 'Situps'),
        ];

    return _getModelFromJson(_staticJsonData!, workoutTypes);
  }

  Future<Model> _getModelFromJson(
      List<dynamic> json, List<WorkoutType> workoutTypes) async {
    final plans = <WorkoutType, List<Level>>{
      for (final type in workoutTypes) type: <Level>[],
    };
    for (int i = 0; i < json.length; i++) {
      final Map<String, dynamic> rawLevel = json[i];
      final List<dynamic> rawSteps = rawLevel['steps'];
      final List<ExerciseStep> steps = <ExerciseStep>[const StartStep()];
      for (final Map<String, dynamic> rawStep in rawSteps) {
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

      for (final entry in plans.entries) {
        final String pushupsID = '${entry.key} $i';
        entry.value.add(await buildLevel(pushupsID));
      }
    }

    return Model(
      <WorkoutType, Plan>{
        for (final entry in plans.entries)
          entry.key: Plan(
            entry.key,
            entry.value,
            await _getIsCalibrated(entry.key),
          ),
      },
    );
  }

  String _key(Date dateType, String id) => dateType.toString() + id;

  Future<DateTime?> _getWorkoutDate(Date dateType, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? dateTimeString = prefs.getString(_key(dateType, id));
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

    _reloadModel();
  }

  Future<void> calibratePlan(
      WorkoutType workoutType, int? calibrationValue) async {
    final Plan plan = model.plans[workoutType]!;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCalibrated:$workoutType', true);

    plan.isCalibrated = await _getIsCalibrated(workoutType);

    if (calibrationValue != null) {
      final int total =
          min(100, max(5, (calibrationValue * kCalibrationMultiplier).toInt()));
      final String workoutID =
          plan.levels.lastWhere((level) => level.total == total).id;
      await setWorkoutDate(Date.completed, workoutID, DateTime.now());
      //not calling to any reload method because [setWorkoutDate] does that
      // internally.
      // this might have a better solution
    } else {
      await _reloadModel();
    }
  }

  Future<void> resetWorkoutType(List<WorkoutType> workoutTypeList) async {
    if (workoutTypeList.isEmpty) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (final WorkoutType workoutType in workoutTypeList) {
      final Plan plan = model.getPlan(workoutType)!;
      for (final Level level in plan.levels) {
        await prefs.remove(_key(Date.completed, level.id));
        await prefs.remove(_key(Date.attempted, level.id));
      }
      await prefs.remove('isCalibrated:$workoutType');
    }
    await _reloadModel();
  }

  ///Updates the [model] (the model) by reloading everything but the json.
  ///
  ///This method assumes [_staticJsonData] is not null
  Future<void> _reloadModel() async {
    final workoutTypes = await _loadWorkoutTypes() ??
        const [
          WorkoutType(id: 'pushups', name: 'Pushups'),
          WorkoutType(id: 'pullups', name: 'Pullups'),
          WorkoutType(id: 'squats', name: 'Squats'),
          WorkoutType(id: 'situps', name: 'Situps'),
        ];
    model = await _getModelFromJson(_staticJsonData!, workoutTypes);
    notifyListeners();
  }

  Future<bool> _getIsCalibrated(WorkoutType workoutType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isCalibrated:$workoutType') ?? false;
  }

  Future<void> _saveWorkoutTypes(List<WorkoutType> types) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_workoutTypesKey, jsonEncode(types));
    _reloadModel();
  }

  Future<List<WorkoutType>?> _loadWorkoutTypes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_workoutTypesKey);
    if (jsonString == null) {
      return null;
    }
    final listOfObjects = jsonDecode(jsonString) as List;
    return listOfObjects.map(WorkoutType.fromJson).toList();
  }

  Future<void> removeWorkoutType(WorkoutType type) async {
    final types = [...model.plans.keys]..remove(type);
    await _saveWorkoutTypes(types);
  }

  Future<void> addWorkoutType(WorkoutType type) async {
    final types = [...model.plans.keys, type];
    await _saveWorkoutTypes(types);
  }
}

enum Date { attempted, completed }
