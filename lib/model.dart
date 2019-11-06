import 'dart:collection';
import 'dart:math';

const String kPushupsString = 'pushups';
const String kPullupsString = 'pullups';
const String kSitupsString = 'situps';
const String kSquatsString = 'squats';

enum WorkoutType {
  pullups,
  pushups,
  situps,
  squats,
}

class Model {
  Model(
    this.pushUpsPlan,
    this.pullUpsPlan,
    this.sitUpsPlan,
    this.squatsPlan,
  );

  final Plan pushUpsPlan;
  final Plan pullUpsPlan;
  final Plan sitUpsPlan;
  final Plan squatsPlan;

  Plan getPlan(WorkoutType workoutType) {
    Plan result;
    switch (workoutType) {
      case WorkoutType.pullups:
        result = pullUpsPlan;
        break;
      case WorkoutType.pushups:
        result = pushUpsPlan;
        break;
      case WorkoutType.situps:
        result = sitUpsPlan;
        break;
      case WorkoutType.squats:
        result = squatsPlan;
        break;
    }
    return result;
  }
}

class Plan {
  Plan(
    this.levels,
  );

  final List<Level> levels;

  List<Level> get activeLevels {
    final int lastCompletedIndex = levels.lastIndexWhere((Level workout) {
      return workout.dateCompleted != null;
    });
    return levels
        .getRange(0, min(lastCompletedIndex + 2, levels.length))
        .toList();
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

    //because we can redo levels now it is possible to have dateAttempted before dateCompleted. This will remain like this until dates will be
    // a list like a log of all attempts and completes
//    if (dateCompleted != null &&
//        dateAttempted != null &&
//        dateCompleted.isBefore(dateAttempted))
//      throw ArgumentError("dateCompleted ($dateCompleted) must be after dateAttempted ($dateAttempted.");
    if (dateAttempted == null && dateCompleted != null)
      throw ArgumentError(
          "dateAttempted can't be null while dateCompleted is not null");
  }

  final String id;
  final List<ExerciseStep> _steps;
  final DateTime dateAttempted;
  final DateTime dateCompleted;

  UnmodifiableListView<ExerciseStep> get steps =>
      UnmodifiableListView<ExerciseStep>(_steps);
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
