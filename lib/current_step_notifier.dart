import 'package:flutter/foundation.dart';
import 'package:pogo/data_provider.dart' as DataProvider;
import 'package:pogo/model.dart';

class CurrentStepNotifier extends ChangeNotifier {
  Workout _workout;
  int _currentStepIndex;

  CurrentStepNotifier(Workout workout) {
    this.workout = workout;
  }

  ExerciseStep get currentStep => _workout.steps[_currentStepIndex];

  set currentStepIndex(int value) {
    if (value >= _workout.steps.length) throw IndexError(value, _workout.steps);
    _currentStepIndex = value;
    if (currentStep is FinishStep) {
      DataProvider.setWorkoutDate(
        DataProvider.Date.completed,
        _workout.id,
        DateTime.now(),
      );
    } else if (currentStep is StartStep) {
      DataProvider.setWorkoutDate(
        DataProvider.Date.attempted,
        _workout.id,
        DateTime.now(),
      );
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
