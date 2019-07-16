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
