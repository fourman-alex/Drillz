import 'package:drillz/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//todo add keys to widget constructors

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            CalibrationBanner(
              onCalibrate: (int value) {},
            ),
            Container(
              height: 50,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}

class CalibrationBanner extends StatefulWidget {
  const CalibrationBanner({Key key, @required this.onCalibrate})
      : super(key: key);

  final void Function(int value) onCalibrate;

  @override
  _CalibrationBannerState createState() => _CalibrationBannerState();
}

class _CalibrationBannerState extends State<CalibrationBanner>
    with SingleTickerProviderStateMixin<CalibrationBanner> {
  final PageController _pageController = PageController();
  AnimationController _slideAnimationController;
  Animation<double> _heightFactorAnimation;
  final ValueNotifier<bool> _isVisibleNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
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
      builder: (BuildContext context, bool isVisible, Widget child) {
        return Visibility(
          child: child,
          visible: isVisible,
        );
      },
      child: AnimatedBuilder(
        animation: _slideAnimationController,
        child: Container(
          height: 160,
          child: Column(
            children: <Widget>[
              Flexible(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    QuestionPage(
                      workoutName: 'pullups',
                      onCalibrate: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      },
                      onSkip: _onDismiss,
                    ),
                    CalibrationPage(
                      workoutName: 'pullups',
                      onCalibrate: (int value) {
                        widget.onCalibrate(value);
                        _onDismiss();
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
        builder: (BuildContext context, Widget child) {
          return ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: _heightFactorAnimation.value,
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _onDismiss() async {
    await _slideAnimationController.forward();
    _isVisibleNotifier.value = false;
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage(
      {@required this.onSkip,
      @required this.onCalibrate,
      @required this.workoutName});

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
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
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
  const CalibrationPage(
      {Key key,
      @required this.workoutName,
      @required this.onCalibrate,
      @required this.onBack})
      : super(key: key);

  final String workoutName;
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
          max: 100,
          value: sliderValue,
          onChanged: (double value) {
            setState(() {
              sliderValue = value;
            });
          },
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
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

final List<ExerciseStep> _steps = <ExerciseStep>[
  StartStep(),
  WorkStep(16),
  RestStep(60),
  WorkStep(13),
  RestStep(60),
  WorkStep(11),
  RestStep(60),
  WorkStep(10),
  RestStep(60),
  WorkStep(9),
  RestStep(60),
  WorkStep(8),
  FinishStep(),
];

final Level _level = Level('level id', _steps, null, null);
