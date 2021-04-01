import 'dart:collection';
import 'dart:math';

const String _pushupsString = 'pushups';
const String _pullupsString = 'pullups';
const String _situpsString = 'situps';
const String _squatsString = 'squats';

enum WorkoutType {
  pullups,
  pushups,
  situps,
  squats,
}

class Model {
  const Model(this.plans);
  factory Model.empty() => const Model({});

  final Map<WorkoutType, Plan> plans;

  Plan getPlan(WorkoutType workoutType) => plans[workoutType];
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
    final int lastCompletedIndex = levels.lastIndexWhere((Level workout) {
      return workout.dateCompleted != null;
    });
    return levels
        .getRange(0, min(lastCompletedIndex + 2, levels.length))
        .toList();
  }

  static String getWorkoutTypeString(WorkoutType workoutType) {
    /*late*/ String result;
    switch (workoutType) {
      case WorkoutType.pullups:
        result = _pullupsString;
        break;
      case WorkoutType.pushups:
        result = _pushupsString;
        break;
      case WorkoutType.situps:
        result = _situpsString;
        break;
      case WorkoutType.squats:
        result = _squatsString;
        break;
    }
    return result;
  }
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

  final String /*!*/ id;
  final List<ExerciseStep> _steps;
  DateTime dateAttempted;
  DateTime dateCompleted;

  UnmodifiableListView<ExerciseStep> get steps =>
      UnmodifiableListView<ExerciseStep>(_steps);

  int get total {
    return steps
        .whereType<WorkStep>()
        .fold(0, (int value, WorkStep step) => value + step.reps);
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

  final int /*!*/ reps;

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
  final int /*!*/ duration;

  @override
  String toString() {
    return duration.toString() + 's';
  }
}

class StartStep extends ExerciseStep {
  const StartStep();

  @override
  String toString() => 'Go';

  @override
  bool operator ==(dynamic other) => other is StartStep;

  @override
  int get hashCode => toString().hashCode;
}

class FinishStep extends ExerciseStep {
  const FinishStep();

  @override
  String toString() => '\u{1F3C1}';

  @override
  bool operator ==(dynamic other) => other is FinishStep;

  @override
  int get hashCode => toString().hashCode;
}
