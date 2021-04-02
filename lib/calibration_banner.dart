import 'package:flutter/material.dart';

class CalibrationBanner extends StatefulWidget {
  const CalibrationBanner({
    required this.onCalibrate,
    required this.onDismiss,
    required this.workoutString,
    required this.maxValue,
    Key? key,
  }) : super(key: key);

  final void Function(int value) onCalibrate;
  final void Function() onDismiss;
  final String workoutString;
  final int maxValue;

  @override
  _CalibrationBannerState createState() => _CalibrationBannerState();
}

class _CalibrationBannerState extends State<CalibrationBanner>
    with SingleTickerProviderStateMixin<CalibrationBanner> {
  final PageController _pageController = PageController();
  late AnimationController _slideAnimationController;
  late Animation<double> _heightFactorAnimation;
  final ValueNotifier<bool> _isVisibleNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _heightFactorAnimation = CurvedAnimation(
        parent: _slideAnimationController.drive(
          Tween<double>(
            begin: 1.0,
            end: 0.0,
          ),
        ),
        curve: Curves.ease);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVisibleNotifier,
      builder: (context, isVisible, child) {
        return Visibility(
          visible: isVisible,
          child: child!,
        );
      },
      child: Material(
        child: AnimatedBuilder(
          animation: _slideAnimationController,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: _heightFactorAnimation.value,
                child: child,
              ),
            );
          },
          child: SizedBox(
            height: 160,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      QuestionPage(
                        workoutName: widget.workoutString,
                        onCalibrate: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        onSkip: () async {
                          await _animateDismiss();
                          widget.onDismiss();
                        },
                      ),
                      CalibrationPage(
                        maxValue: widget.maxValue,
                        workoutName: widget.workoutString,
                        onCalibrate: (int value) async {
                          await _animateDismiss();
                          widget.onCalibrate(value);
                        },
                        onBack: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _animateDismiss() async {
    await _slideAnimationController.forward();
    _isVisibleNotifier.value = false;
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage(
      {required this.onSkip,
      required this.onCalibrate,
      required this.workoutName});

  final String workoutName;
  final void Function() onSkip;
  final void Function() onCalibrate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Too easy?',
              style: Theme.of(context).textTheme.body1!.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
              'Lets calibrate, by setting the max amount of $workoutName you can do in one set'),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () => onCalibrate(),
              child: const Text('CALIBRATE'),
            ),
            Container(
              width: 8,
            ),
            FlatButton(
              onPressed: () => onSkip(),
              child: const Text('DISMISS'),
            ),
          ],
        ),
      ],
    );
  }
}

class CalibrationPage extends StatefulWidget {
  const CalibrationPage({
    Key? key,
    required this.workoutName,
    required this.onCalibrate,
    required this.onBack,
    required this.maxValue,
  }) : super(key: key);

  final String workoutName;
  final int maxValue;
  final void Function(int value) onCalibrate;
  final void Function() onBack;

  @override
  _CalibrationPageState createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage> {
  double sliderValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Max ${widget.workoutName}',
              ),
              Text(
                sliderValue.toInt().toString(),
              ),
            ],
          ),
        ),
        Slider(
          label: '10',
          min: 1,
          max: widget.maxValue.toDouble(),
          value: sliderValue,
          onChanged: (double value) {
            setState(() {
              sliderValue = value;
            });
          },
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: const Text('BACK'),
              onPressed: widget.onBack,
            ),
            FlatButton(
              child: const Text('CALIBRATE'),
              onPressed: () => widget.onCalibrate(sliderValue.toInt()),
            ),
          ],
        )
      ],
    );
  }
}
