import 'steps.dart';

class Workout {
  final String id;
  final List<ExerciseStep> steps;

  const Workout(
    this.id,
    this.steps,
  );
}

const List<ExerciseStep> _steps1 = [
  StartStep(),
  WorkStep(7),
  RestStep(10),
  WorkStep(6),
  RestStep(10),
  WorkStep(5),
  RestStep(10),
  WorkStep(6),
  RestStep(10),
  WorkStep(7),
  RestStep(10),
  FinishStep(),
];

const List<ExerciseStep> _steps2 = [
  StartStep(),
  WorkStep(3),
  RestStep(8),
  WorkStep(5),
  RestStep(10),
  FinishStep(),
];

const List<ExerciseStep> _steps3 = [
  StartStep(),
  WorkStep(2),
  RestStep(2),
  WorkStep(5),
  RestStep(10),
  FinishStep(),
];

const List<Workout> plan = [
  Workout("level 1", _steps1),
  Workout("level 2", _steps2),
  Workout("level 3", _steps3),
];