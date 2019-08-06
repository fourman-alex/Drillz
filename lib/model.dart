import 'dart:collection';

class WorkoutSelection {
  final List<Level> pushUpsPlan;
  final List<Level> pullUpsPlan;
  final List<Level> sitUpsPlan;
  final List<Level> squatsPlan;

  WorkoutSelection(
      this.pushUpsPlan, this.pullUpsPlan, this.sitUpsPlan, this.squatsPlan);
}

class Level {
  final String id;
  final List<ExerciseStep> _steps;
  final DateTime dateAttempted;
  final DateTime dateCompleted;

  const Level(
    this.id,
    List<ExerciseStep> steps,
    this.dateAttempted,
    this.dateCompleted,
  ) : _steps = steps;

  UnmodifiableListView<ExerciseStep> get steps => UnmodifiableListView(_steps);
}

abstract class ExerciseStep {
  const ExerciseStep();
}

class WorkStep extends ExerciseStep {
  final int reps;

  const WorkStep(this.reps);

  @override
  String toString() {
    return reps.toString();
  }
}

class RestStep extends ExerciseStep {
  /// Rest [duration] in seconds
  final int duration;

  const RestStep(this.duration);

  @override
  String toString() {
    return duration.toString();
  }
}

class StartStep extends ExerciseStep {
  const StartStep();

  @override
  String toString() => "Start";

  @override
  bool operator ==(other) => other is StartStep;

  @override
  int get hashCode => toString().hashCode;
}

class FinishStep extends ExerciseStep {
  const FinishStep();

  @override
  String toString() => "Finish";

  @override
  bool operator ==(other) => other is FinishStep;

  @override
  int get hashCode => toString().hashCode;
}
