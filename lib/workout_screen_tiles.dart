import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo/audio.dart';
import 'package:pogo/consts.dart';

class StartTile extends StatelessWidget {
  final VoidCallback _onPressed;

  StartTile({@required VoidCallback onPressed}) : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onPressed,
      child: SizedBox.expand(
        child: FittedBox(
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              "GO",
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontFamily: Consts.righteousFont),
            ),
          ),
        ),
      ),
    );
  }
}

class FinishTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.popUntil(context, ModalRoute.withName("/"));
      },
      child: RotatedBox(
        quarterTurns: 1,
        child: SizedBox.expand(
          child: FittedBox(
            child: Text(
              "Finish",
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontFamily: Consts.righteousFont),
            ),
          ),
        ),
      ),
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
    return RotatedBox(
      quarterTurns: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onPressed,
        child: SizedBox.expand(
          child: FittedBox(
            child: Text("$_amount",
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold)),
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
    //start timer when created
    var duration = _timerString;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(timer.tick);
      if (timer.tick > duration) {
        audioPlayer.play(Consts.bellsAudio);
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
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            curve: Curves.elasticOut,
            duration: Duration(milliseconds: 750),
            color: Theme.of(context).primaryColorDark,
            height: _progressBarHeight,
          ),
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox.expand(
                  child: FittedBox(
                    child: Text(
                      "Rest for",
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: SizedBox.expand(
                  child: FittedBox(
                    child: Text(
                      "${_timerString.toString()}",
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
