import 'package:flutter_test/flutter_test.dart';
import 'package:pogo/model.dart';

void main() {
  final dummySteps = [
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

  group("ExerciseStep", () {
    test("WorkStep args", () {
      expect(() => WorkStep(null), throwsArgumentError);
      expect(() => WorkStep(-1), throwsArgumentError);
    });
    test("RestStep args", () {
      expect(() => RestStep(null), throwsArgumentError);
      expect(() => RestStep(-1), throwsArgumentError);
    });
    test("StartStep equals", () {
      expect(StartStep() == StartStep(), true);
    });
    test("FinishStep equals", () {
      expect(FinishStep() == FinishStep(), true);
      expect(StartStep() != FinishStep(), true);
    });
  });

  group("Level", () {
    test("completed before attempted dates", () {
      expect(() => Level("some id", dummySteps, DateTime(2019), DateTime(2018)),
          throwsArgumentError);
    });
    test("id not null", () {
      expect(() => Level(null, dummySteps, DateTime(2018), DateTime(2019)),
          throwsArgumentError);
    });
  });
  group("Model test", () {
    test("null args", () {
      final dummyLevel = Level(
        "level id",
        dummySteps,
        DateTime(2018),
        DateTime(2019),
      );
      final dummyLevels = [dummyLevel, dummyLevel, dummyLevel];
      expect(() => Model(null, null, null, null), throwsArgumentError);
      expect(
          () => Model(
                dummyLevels,
                dummyLevels,
                dummyLevels,
                null,
              ),
          throwsArgumentError);
      expect(
          () => Model(
                dummyLevels,
                dummyLevels,
                null,
                dummyLevels,
              ),
          throwsArgumentError);
      expect(
          () => Model(
                dummyLevels,
                null,
                dummyLevels,
                dummyLevels,
              ),
          throwsArgumentError);
      expect(
          () => Model(
                null,
                dummyLevels,
                dummyLevels,
                dummyLevels,
              ),
          throwsArgumentError);
    });
  });
}
