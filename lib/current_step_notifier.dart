import 'package:flutter/foundation.dart';
//todo provide the DataProvider so it can be mocked for testing
import 'package:pogo/data_provider.dart' as DataProvider;
import 'package:pogo/model.dart';

class CurrentStepNotifier extends ChangeNotifier {
  Workout workout;
  int _currentStepIndex = 0;

  CurrentStepNotifier(Workout workout) : this.workout = workout {
    //check params
    if (workout is! Workout) throw ArgumentError(workout);
  }

  ExerciseStep get currentStep => workout.steps[_currentStepIndex];

  set currentStepIndex(int value) {
    if (value >= workout.steps.length) throw IndexError(value, workout.steps);
    _currentStepIndex = value;
    if (currentStep is FinishStep) {
      DataProvider.setWorkoutDate(
        DataProvider.Date.completed,
        workout.id,
        DateTime.now(),
      );
    } else if (currentStep is StartStep) {
      DataProvider.setWorkoutDate(
        DataProvider.Date.attempted,
        workout.id,
        DateTime.now(),
      );
    }
    notifyListeners();
  }

  int get currentStepIndex => _currentStepIndex;
}
