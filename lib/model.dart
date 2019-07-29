import 'dart:collection';

class WorkoutSelection {
  final List<Workout> pushUpsPlan;
  final List<Workout> pullUpsPlan;
  final List<Workout> sitUpsPlan;
  final List<Workout> squatsPlan;

  WorkoutSelection(this.pushUpsPlan, this.pullUpsPlan, this.sitUpsPlan, this.squatsPlan);
}

class Workout {
  final String id;
  final List<ExerciseStep> _steps;
  final DateTime dateAttempted;
  final DateTime dateCompleted;

  const Workout(
    this.id,
    List<ExerciseStep> steps, this.dateAttempted, this.dateCompleted,
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
  String toString() {
    return "Start";
  }
}

class FinishStep extends ExerciseStep {
  const FinishStep();

  @override
  String toString() {
    return "Finish";
  }
}
