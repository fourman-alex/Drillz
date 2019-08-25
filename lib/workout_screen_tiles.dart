import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/repository.dart';
import 'package:pogo/model.dart';
import 'package:provider/provider.dart';

class StartTile extends StatelessWidget {
  final VoidCallback _onPressed;

  StartTile({@required VoidCallback onPressed}) : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.expand(
      child: FittedBox(
        child: GestureDetector(
          onTap: _onPressed,
          child: Text(
            "Start",
          ),
        ),
      ),
    ));
  }
}

class FinishTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var workoutSelectionNotifier =
            Provider.of<ValueNotifier<Model>>(context, listen: false)
              ..value = null;
        Repository.modelAsync
            .then((model) => workoutSelectionNotifier.value = model);
        Navigator.popUntil(context, ModalRoute.withName("/"));
      },
      child: Center(
          child: SizedBox.expand(
        child: FittedBox(
          child: Text(
            "Done!",
          ),
        ),
      )),
    );
  }
}

class WorkTile extends StatelessWidget {
  final int _amount;
  final VoidCallback _onPressed;

  WorkTile({@required int reps, @required VoidCallback onPressed})
      : _onPressed = onPressed,
        _amount = reps;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        child: GestureDetector(
          onTap: _onPressed,
          child: Text(
            "Perform $_amount",
          ),
        ),
      ),
    );
  }
}

class RestTile extends StatefulWidget {
  final int duration;
  final VoidCallback _onDone;

  @override
  _RestTileState createState() => _RestTileState();

  RestTile({Key key, @required this.duration, @required VoidCallback onDone})
      : _onDone = onDone,
        super(key: key);
}

class _RestTileState extends State<RestTile>
    with AutomaticKeepAliveClientMixin<RestTile> {
  double _progressBarHeight = 0;
  int _timerString;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timerString = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                curve: Curves.elasticOut,
                duration: Duration(milliseconds: 750),
                color: Theme.of(context).primaryColorDark,
                height: _progressBarHeight,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Rest",
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    "${_timerString.toString().padLeft(2, '0')}:00",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTap() {
    //makes tap do nothing after timer has started
    if (_timer != null && _timer.isActive) return;

    var duration = _timerString;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(timer.tick);
      if (timer.tick > duration) {
        timer.cancel();
        widget._onDone();
      } else {
        setState(() {
          _progressBarHeight = context.size.height * (timer.tick / duration);
          _timerString = (duration - timer.tick);
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
