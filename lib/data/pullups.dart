import 'package:pogo/model.dart';

const List<ExerciseStep> _level1 = [
  StartStep(),
  WorkStep(2),
  RestStep(60),
  WorkStep(1),
  RestStep(60),
  WorkStep(1),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(3),
  FinishStep(),
];

const List<ExerciseStep> _level2 = [
  StartStep(),
  WorkStep(2),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(1),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(3),
  FinishStep(),
];

const List<ExerciseStep> _level3 = [
  StartStep(),
  WorkStep(2),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(3),
  FinishStep(),
];

const List<ExerciseStep> _level4 = [
  StartStep(),
  WorkStep(3),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(3),
  FinishStep(),
];

const List<ExerciseStep> _level5 = [
  StartStep(),
  WorkStep(3),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(3),
  FinishStep(),
];

const List<ExerciseStep> _level6 = [
  StartStep(),
  WorkStep(3),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(2),
  RestStep(60),
  WorkStep(5),
  FinishStep(),
];

const List<ExerciseStep> _level7 = [
  StartStep(),
  WorkStep(4),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(4),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(4),
  FinishStep(),
];

const List<ExerciseStep> _level8 = [
  StartStep(),
  WorkStep(5),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(4),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(5),
  FinishStep(),
];

const List<ExerciseStep> _level9 = [
  StartStep(),
  WorkStep(6),
  RestStep(60),
  WorkStep(5),
  RestStep(60),
  WorkStep(4),
  RestStep(60),
  WorkStep(3),
  RestStep(60),
  WorkStep(6),
  FinishStep(),
];

const List<ExerciseStep> _level10 = [
  StartStep(),
  WorkStep(5),
  RestStep(60),
  WorkStep(4),
  RestStep(60),
  WorkStep(5),
  RestStep(60),
  WorkStep(6),
  RestStep(60),
  WorkStep(7),
  FinishStep(),
];

const List<ExerciseStep> _level11 = [
  StartStep(),
  WorkStep(7),
  RestStep(60),
  WorkStep(6),
  RestStep(60),
  WorkStep(5),
  RestStep(60),
  WorkStep(6),
  RestStep(60),
  WorkStep(7),
  FinishStep(),
];

const List<ExerciseStep> _level12 = [
  StartStep(),
  WorkStep(8),
  RestStep(60),
  WorkStep(6),
  RestStep(60),
  WorkStep(5),
  RestStep(60),
  WorkStep(4),
  RestStep(60),
  WorkStep(7),
  RestStep(60),
  WorkStep(6),
  FinishStep(),
];

const List<Map<String, Object>> pullupsData = [
  {"id": "PullUps Level 1", "steps": _level1},
  {"id": "PullUps Level 2", "steps": _level2},
  {"id": "PullUps Level 3", "steps": _level3},
  {"id": "PullUps Level 4", "steps": _level4},
  {"id": "PullUps Level 5", "steps": _level5},
  {"id": "PullUps Level 6", "steps": _level6},
  {"id": "PullUps Level 7", "steps": _level7},
  {"id": "PullUps Level 8", "steps": _level8},
  {"id": "PullUps Level 9", "steps": _level9},
  {"id": "PullUps Level 10", "steps": _level10},
  {"id": "PullUps Level 11", "steps": _level11},
  {"id": "PullUps Level 12", "steps": _level12},
];
