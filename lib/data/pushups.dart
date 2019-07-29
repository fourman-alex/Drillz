import 'package:pogo/model.dart';

const List<ExerciseStep> _pushupsLevel1 = [
  StartStep(),
  WorkStep(2),
  RestStep(120),
  WorkStep(2),
  RestStep(120),
  WorkStep(3),
  RestStep(120),
  WorkStep(2),
  RestStep(120),
  WorkStep(3),
  FinishStep(),
];

const List<ExerciseStep> _pushupsLevel2 = [
  StartStep(),
  WorkStep(3),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(3),
  RestStep(120),
  WorkStep(2),
  RestStep(120),
  WorkStep(4),
  FinishStep(),
];

const List<ExerciseStep> _pushupsLevel3 = [
  StartStep(),
  WorkStep(4),
  RestStep(120),
  WorkStep(5),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(5),
  FinishStep(),
];

const List<ExerciseStep> _level4 = [
  StartStep(),
  WorkStep(4),
  RestStep(120),
  WorkStep(6),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(6),
  FinishStep(),
];

const List<ExerciseStep> _level5 = [
  StartStep(),
  WorkStep(5),
  RestStep(120),
  WorkStep(7),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(4),
  RestStep(120),
  WorkStep(6),
  FinishStep(),
];

const List<ExerciseStep> _level6 = [
  StartStep(),
  WorkStep(5),
  RestStep(120),
  WorkStep(8),
  RestStep(120),
  WorkStep(5),
  RestStep(120),
  WorkStep(5),
  RestStep(120),
  WorkStep(7),
  FinishStep(),
];

const List<ExerciseStep> _level7 = [
  StartStep(),
  WorkStep(10),
  RestStep(120),
  WorkStep(7),
  RestStep(120),
  WorkStep(12),
  RestStep(120),
  WorkStep(7),
  RestStep(120),
  WorkStep(9),
  FinishStep(),
];

const List<ExerciseStep> _level8 = [
  StartStep(),
  WorkStep(10),
  RestStep(120),
  WorkStep(8),
  RestStep(120),
  WorkStep(12),
  RestStep(120),
  WorkStep(8),
  RestStep(120),
  WorkStep(12),
  FinishStep(),
];

const List<ExerciseStep> _level9 = [
  StartStep(),
  WorkStep(11),
  RestStep(120),
  WorkStep(9),
  RestStep(120),
  WorkStep(13),
  RestStep(120),
  WorkStep(9),
  RestStep(120),
  WorkStep(13),
  FinishStep(),
];

const List<ExerciseStep> _level10 = [
  StartStep(),
  WorkStep(12),
  RestStep(120),
  WorkStep(16),
  RestStep(120),
  WorkStep(11),
  RestStep(120),
  WorkStep(10),
  RestStep(120),
  WorkStep(14),
  FinishStep(),
];

const List<ExerciseStep> _level11 = [
  StartStep(),
  WorkStep(14),
  RestStep(120),
  WorkStep(18),
  RestStep(120),
  WorkStep(12),
  RestStep(120),
  WorkStep(12),
  RestStep(120),
  WorkStep(16),
  FinishStep(),
];

const List<ExerciseStep> _level12 = [
  StartStep(),
  WorkStep(16),
  RestStep(120),
  WorkStep(20),
  RestStep(120),
  WorkStep(13),
  RestStep(120),
  WorkStep(13),
  RestStep(120),
  WorkStep(18),
  FinishStep(),
];

const List<Map<String, Object>> pushUpsData = [
  {"id": "PushUps Level 1", "steps": _pushupsLevel1},
  {"id": "PushUps Level 2", "steps": _pushupsLevel2},
  {"id": "PushUps Level 3", "steps": _pushupsLevel3},
  {"id": "PushUps Level 4", "steps": _level4},
  {"id": "PushUps Level 5", "steps": _level5},
  {"id": "PushUps Level 6", "steps": _level6},
  {"id": "PushUps Level 7", "steps": _level7},
  {"id": "PushUps Level 8", "steps": _level8},
  {"id": "PushUps Level 9", "steps": _level9},
  {"id": "PushUps Level 10", "steps": _level10},
  {"id": "PushUps Level 11", "steps": _level11},
  {"id": "PushUps Level 12", "steps": _level12},
];
