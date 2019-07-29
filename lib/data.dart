import 'model.dart';

const List<ExerciseStep> _pushupsLevel1 = [
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

const List<ExerciseStep> _pushupsLevel2 = [
  StartStep(),
  WorkStep(3),
  RestStep(8),
  WorkStep(5),
  RestStep(10),
  FinishStep(),
];

const List<ExerciseStep> _pushupsLevel3 = [
  StartStep(),
  WorkStep(2),
  RestStep(2),
  WorkStep(5),
  RestStep(10),
  FinishStep(),
];

const List<Map<String, Object>> pushUpsLevelSelection = [
  {"id": "PushUps Level 1", "steps": _pushupsLevel1},
  {"id": "PushUps Level 2", "steps": _pushupsLevel2},
  {"id": "PushUps Level 3", "steps": _pushupsLevel3},
];