import 'package:flutter_test/flutter_test.dart';
import 'package:drillz/model.dart';

void main() {
  final List<ExerciseStep> dummySteps = <ExerciseStep>[
    const StartStep(),
    WorkStep(2),
    RestStep(60),
    WorkStep(2),
    RestStep(60),
    WorkStep(1),
    RestStep(60),
    WorkStep(2),
    RestStep(60),
    WorkStep(3),
    const FinishStep(),
  ];

  group('ExerciseStep', () {
    test('WorkStep args', () {
      expect(() => WorkStep(-1), throwsArgumentError);
    });
    test('RestStep args', () {
      expect(() => RestStep(-1), throwsArgumentError);
    });
  });

  group('Level', () {
    test('completed before attempted dates', () {
      expect(() => Level('some id', dummySteps, DateTime(2019), DateTime(2018)),
          throwsArgumentError);
    });
  });
  group('Model test', () {
//    test('null args', () {
//      final Level dummyLevel = Level(
//        'level id',
//        dummySteps,
//        DateTime(2018),
//        DateTime(2019),
//      );
//
//      final List<Level> dummyLevels = <Level>[
//        dummyLevel,
//        dummyLevel,
//        dummyLevel
//      ];
//      final Plan dummyPlanSquats = Plan(WorkoutType.squats,dummyLevels,false);
//      final Plan dummyPlanSitups = Plan(WorkoutType.situps,dummyLevels,false);
//      final Plan dummyPlanPullups = Plan(WorkoutType.pullups,dummyLevels,false);
//      final Plan dummyPlanPushups = Plan(WorkoutType.pushups,dummyLevels,false);
//      final Map<WorkoutType,Plan> plans = <WorkoutType,Plan> {
//        WorkoutType.squats: dummyPlanSquats,
//        WorkoutType.situps: dummyPlanSitups,
//        WorkoutType.pullups: dummyPlanPullups,
//        WorkoutType.pushups: dummyPlanPushups,
//      };
//      expect(() => Model(plans), throwsArgumentError);
//      expect(
//          () => Model(
//                dummyPlanPullups,
//                dummyLevels,
//                dummyLevels,
//                null,
//              ),
//          throwsArgumentError);
//      expect(
//          () => Model(
//                dummyLevels,
//                dummyLevels,
//                null,
//                dummyLevels,
//              ),
//          throwsArgumentError);
//      expect(
//          () => Model(
//                dummyLevels,
//                null,
//                dummyLevels,
//                dummyLevels,
//              ),
//          throwsArgumentError);
//      expect(
//          () => Model(
//                null,
//                dummyLevels,
//                dummyLevels,
//                dummyLevels,
//              ),
//          throwsArgumentError);
//    });
  });
}
