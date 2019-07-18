import 'steps.dart';

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

const List<Map<String, Object>> plan = [
  {"id": "Level 1", "steps": _steps1},
  {"id": "Level 2", "steps": _steps2},
  {"id": "Level 3", "steps": _steps3},
];