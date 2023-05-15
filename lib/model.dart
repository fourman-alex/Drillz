import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutType extends Equatable {
  const WorkoutType({required this.id, required this.name});

  factory WorkoutType.fromJson(json) {
    return WorkoutType(
      id: json['id'],
      name: json['name'],
    );
  }

  final String id;
  final String name;

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;

  Map toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

@immutable
class Model {
  const Model(this.plans);

  factory Model.empty() => const Model({});

  final Map<WorkoutType, Plan> plans;

  Plan? getPlan(WorkoutType workoutType) => plans[workoutType];
}

class Plan {
  Plan(
    this.workoutType,
    this.levels,
    this.isCalibrated,
  );

  final WorkoutType workoutType;
  final List<Level> levels;

  bool isCalibrated;

  bool get notCalibrated => !isCalibrated;

  List<Level> get activeLevels {
    final int lastCompletedIndex = levels.lastIndexWhere((workout) {
      return workout.dateCompleted != null;
    });
    return levels
        .getRange(0, min(lastCompletedIndex + 2, levels.length))
        .toList();
  }

  static String getWorkoutTypeString(WorkoutType workoutType) => workoutType.id;
}

@immutable
class Level {
  /// [dateCompleted] must come after [dateAttempted].
  ///
  /// [dateAttempted] can't be null if [dateCompleted] is not null.
  const Level(
    this.id,
    List<ExerciseStep> steps,
    this.dateAttempted,
    this.dateCompleted,
  ) : _steps = steps;

  final String id;
  final List<ExerciseStep> _steps;
  final DateTime? dateAttempted;
  final DateTime? dateCompleted;

  UnmodifiableListView<ExerciseStep> get steps =>
      UnmodifiableListView<ExerciseStep>(_steps);

  int get total {
    return steps
        .whereType<WorkStep>()
        .fold(0, (value, step) => value + step.reps);
  }
}

@immutable
abstract class ExerciseStep {
  const ExerciseStep();
}

@immutable
class WorkStep extends ExerciseStep {
  WorkStep(this.reps) {
    if (reps <= 0) {
      throw ArgumentError(reps);
    }
  }

  final int reps;

  @override
  String toString() {
    return reps.toString();
  }
}

@immutable
class RestStep extends ExerciseStep {
  RestStep(this.duration) {
    if (duration <= 0) {
      throw ArgumentError(duration);
    }
  }

  /// Rest [duration] in seconds
  final int duration;

  @override
  String toString() {
    return '${duration}s';
  }
}

@immutable
class StartStep extends ExerciseStep {
  const StartStep();

  @override
  String toString() => 'Go';

  @override
  bool operator ==(Object other) => other is StartStep;

  @override
  int get hashCode => toString().hashCode;
}

@immutable
class FinishStep extends ExerciseStep {
  const FinishStep();

  @override
  String toString() => 'End';

  @override
  bool operator ==(Object other) => other is FinishStep;

  @override
  int get hashCode => toString().hashCode;
}
