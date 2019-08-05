import 'package:flutter_test/flutter_test.dart';
import 'package:pogo/current_step_notifier.dart';
import 'package:pogo/model.dart';

var normalWorkout = Workout(
  "Pushups level 1",
  const [
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
  ],
  DateTime(2019, 5, 20),
  DateTime(2019, 6, 14),
);

void main() {
  test("null check", () {
    expect(() => CurrentStepNotifier(null), throwsArgumentError);
  });

  group("CurrentStepNotifier state after construction", () {
    CurrentStepNotifier stepNotifier;

    setUp(() => stepNotifier = CurrentStepNotifier(normalWorkout));

    test("currentStepIndex value is 0 after construction", () {
      expect(stepNotifier.currentStepIndex, 0);
    });

    test("currentStep is StartStep after construction", () {
      expect(stepNotifier.currentStep, StartStep());
    });
  });
}
