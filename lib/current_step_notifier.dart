import 'package:flutter/foundation.dart';
import 'package:pogo/steps.dart';

import 'data_provider.dart' as DataProvider;

class CurrentStepNotifier extends ChangeNotifier {
  Workout _workout;
  int _currentStepIndex;

  ExerciseStep get currentStep => _workout.steps[_currentStepIndex];

  set currentStepIndex(int value) {
    if (value >= _workout.steps.length) throw IndexError(value, _workout.steps);
    _currentStepIndex = value;
    if (currentStep is FinishStep) {
      DataProvider.setWorkoutCompleted(_workout.id, DateTime.now());
    } else if (currentStep is StartStep) {
      DataProvider.setWorkoutAttempted(_workout.id, DateTime.now());
    }
    notifyListeners();
  }

  int get currentStepIndex => _currentStepIndex;

  get workout => _workout;

  set workout(Workout value) {
    _workout = value;
    //use the setter to funnel all "set" calls to a single place.
    // Also, it will trigger `notifyListeners()` call
    currentStepIndex = 0;
  }
}
