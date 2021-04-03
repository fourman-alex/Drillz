import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class WorkoutType extends Equatable {
  const WorkoutType({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}

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

class Level {
  /// [dateCompleted] must come after [dateAttempted].
  ///
  /// [dateAttempted] can't be null if [dateCompleted] is not null.
  Level(
    this.id,
    List<ExerciseStep> steps,
    this.dateAttempted,
    this.dateCompleted,
  ) : _steps = steps {
    if (id is! String) {
      throw ArgumentError(id);
    }
  }

  final String id;
  final List<ExerciseStep> _steps;
  DateTime? dateAttempted;
  DateTime? dateCompleted;

  UnmodifiableListView<ExerciseStep> get steps =>
      UnmodifiableListView<ExerciseStep>(_steps);

  int get total {
    return steps
        .whereType<WorkStep>()
        .fold(0, (value, step) => value + step.reps);
  }
}

abstract class ExerciseStep {
  const ExerciseStep();
}

class WorkStep extends ExerciseStep {
  WorkStep(this.reps) {
    if (reps is! int || reps <= 0) {
      throw ArgumentError(reps);
    }
  }

  final int reps;

  @override
  String toString() {
    return reps.toString();
  }
}

class RestStep extends ExerciseStep {
  RestStep(this.duration) {
    if (duration is! int || duration <= 0) {
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
  String toString() => '\u{1F3C1}';

  @override
  bool operator ==(Object other) => other is FinishStep;

  @override
  int get hashCode => toString().hashCode;
}
