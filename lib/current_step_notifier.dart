import 'package:flutter/foundation.dart';
import 'package:pogo/repository.dart';
import 'package:pogo/model.dart';

class CurrentStepNotifier extends ChangeNotifier {
  Level workout;
  int _currentStepIndex = 0;

  CurrentStepNotifier(Level workout) : this.workout = workout {
    //check params
    if (workout is! Level) throw ArgumentError(workout);
  }

  ExerciseStep get currentStep => workout.steps[_currentStepIndex];

  set currentStepIndex(int value) {
    if (value >= workout.steps.length) throw IndexError(value, workout.steps);
    _currentStepIndex = value;
    if (currentStep is FinishStep) {
      Repository.setWorkoutDate(
        Date.completed,
        workout.id,
        DateTime.now(),
      );
    } else if (currentStep is StartStep) {
      Repository.setWorkoutDate(
        Date.attempted,
        workout.id,
        DateTime.now(),
      );
    }
    notifyListeners();
  }

  int get currentStepIndex => _currentStepIndex;
}
