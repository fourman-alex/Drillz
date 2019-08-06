import 'package:flutter/foundation.dart';
import 'package:pogo/repository.dart';
import 'package:pogo/model.dart';

class CurrentStepNotifier extends ChangeNotifier {
  Level level;
  int _currentStepIndex = 0;

  CurrentStepNotifier(Level workout) : this.level = workout {
    //check params
    if (workout is! Level) throw ArgumentError(workout);
  }

  ExerciseStep get currentStep => level.steps[_currentStepIndex];

  set currentStepIndex(int value) {
    if (value >= level.steps.length) throw IndexError(value, level.steps);
    _currentStepIndex = value;
    if (currentStep is FinishStep) {
      Repository.setWorkoutDate(
        Date.completed,
        level.id,
        DateTime.now(),
      );
    } else if (currentStep is StartStep) {
      Repository.setWorkoutDate(
        Date.attempted,
        level.id,
        DateTime.now(),
      );
    }
    notifyListeners();
  }

  int get currentStepIndex => _currentStepIndex;
}
