import 'dart:collection';

class Model {
  final List<Level> pushUpsPlan;
  final List<Level> pullUpsPlan;
  final List<Level> sitUpsPlan;
  final List<Level> squatsPlan;

  Model(
    this.pushUpsPlan,
    this.pullUpsPlan,
    this.sitUpsPlan,
    this.squatsPlan,
  ) {
    if (pullUpsPlan is! List<Level>) throw ArgumentError(pullUpsPlan);
    if (pushUpsPlan is! List<Level>) throw ArgumentError(pushUpsPlan);
    if (sitUpsPlan is! List<Level>) throw ArgumentError(sitUpsPlan);
    if (squatsPlan is! List<Level>) throw ArgumentError(squatsPlan);
  }
}

class Level {
  final String id;
  final List<ExerciseStep> _steps;
  final DateTime dateAttempted;
  final DateTime dateCompleted;

  /// [dateCompleted] must come after [dateAttempted].
  ///
  /// [dateAttempted] can't be null if [dateCompleted] is not null.
  Level(
    this.id,
    List<ExerciseStep> steps,
    this.dateAttempted,
    this.dateCompleted,
  ) : _steps = steps {
    if (id is! String) throw ArgumentError(id);
    //because we can redo levels now it is possible to have dateAttempted before dateCompleted. This will remain like this until dates will be
    // a list like a log of all attempts and completes
//    if (dateCompleted != null &&
//        dateAttempted != null &&
//        dateCompleted.isBefore(dateAttempted))
//      throw ArgumentError("dateCompleted ($dateCompleted) must be after dateAttempted ($dateAttempted.");
    if (dateAttempted == null && dateCompleted != null) throw ArgumentError("dateAttempted can't be null while dateCompleted is not null");
  }

  UnmodifiableListView<ExerciseStep> get steps => UnmodifiableListView(_steps);
}

abstract class ExerciseStep {
  const ExerciseStep();
}

class WorkStep extends ExerciseStep {
  final int reps;

  WorkStep(this.reps) {
    if (reps is! int || reps <= 0) throw ArgumentError(reps);
  }

  @override
  String toString() {
    return reps.toString();
  }
}

class RestStep extends ExerciseStep {
  /// Rest [duration] in seconds
  final int duration;

  RestStep(this.duration) {
    if (duration is! int || duration <= 0) throw ArgumentError(duration);
  }

  @override
  String toString() {
    return duration.toString()+"s";
  }
}

class StartStep extends ExerciseStep {
  const StartStep();

  @override
  String toString() => "Go";

  @override
  bool operator ==(other) => other is StartStep;

  @override
  int get hashCode => toString().hashCode;
}

class FinishStep extends ExerciseStep {
  const FinishStep();

  @override
  String toString() => "\u{1F3C1}";

  @override
  bool operator ==(other) => other is FinishStep;

  @override
  int get hashCode => toString().hashCode;
}
