import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:pogo/steps.dart';

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
