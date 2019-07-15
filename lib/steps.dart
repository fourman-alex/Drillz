import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

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

class CurrentStepNotifier extends ChangeNotifier {
  final List<ExerciseStep> _steps = [];
  int _currentStepIndex;

  ExerciseStep get currentStep => _steps[_currentStepIndex];

  set currentStepIndex(int value) {
    if (value >= _steps.length) throw IndexError(value, _steps);
    _currentStepIndex = value;
    notifyListeners();
  }

  int get currentStepIndex => _currentStepIndex;

  UnmodifiableListView<ExerciseStep> get workout =>
      UnmodifiableListView(_steps);

  set steps(List<ExerciseStep> value) {
    _steps.addAll(value);
    _currentStepIndex = 0;
    notifyListeners();
  }

  void incrementStep() {
    if (_currentStepIndex + 1 < _steps.length) {
      _currentStepIndex++;
      notifyListeners();
    }
  }
}
