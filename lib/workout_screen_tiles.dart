import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:drillz/audio.dart';
import 'package:drillz/consts.dart';

class StartTile extends StatelessWidget {
  const StartTile({@required VoidCallback onPressed}) : _onPressed = onPressed;

  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onPressed,
      child: SizedBox.expand(
        child: FittedBox(
          child: Text(
            'GO',
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontFamily: Consts.righteousFont),
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
        final NavigatorState navigator = Navigator.of(context);
        navigator.removeRouteBelow(ModalRoute.of(context));
        navigator.pop();
      },
      child: SizedBox.expand(
        child: FittedBox(
          child: Text(
            'Finish',
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontFamily: Consts.righteousFont),
          ),
        ),
      ),
    );
  }
}

class WorkTile extends StatelessWidget {
  const WorkTile({@required int reps, @required VoidCallback onPressed})
      : _onPressed = onPressed,
        _amount = reps;

  final int _amount;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onPressed,
      child: SizedBox.expand(
        child: FittedBox(
          child: Text('$_amount',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class RestTile extends StatefulWidget {
  const RestTile(
      {Key key, @required this.duration, @required VoidCallback onDone})
      : _onDone = onDone,
        super(key: key);

  final int duration;
  final VoidCallback _onDone;

  @override
  _RestTileState createState() => _RestTileState();
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
    final int duration = _timerString;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      print(timer.tick);
      if (timer.tick > duration) {
        audioPlayer.play(Consts.bellsAudio);
        timer.cancel();
        widget._onDone();
      } else {
        setState(() {
          _progressBarHeight = context.size.height * (timer.tick / duration);
          _timerString = duration - timer.tick;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Rest'),
      ),
      body: Stack(
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
          SizedBox.expand(
            child: FittedBox(
              child: Text(
                '${_timerString.toString()}',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
//        Column(
//          children: <Widget>[
//            Expanded(
//              child: SizedBox.expand(
//                child: FittedBox(
//                  child: Text(
//                    'Rest',
//                    style: Theme.of(context).textTheme.body1.copyWith(
//                          fontWeight: FontWeight.bold,
//                          fontFamily: Consts.righteousFont,
//                        ),
//                  ),
//                ),
//              ),
//            ),
//            Expanded(
//              flex: 4,
//              child: SizedBox.expand(
//                child: FittedBox(
//                  child: Text(
//                    '${_timerString.toString()}',
//                    style: Theme.of(context)
//                        .textTheme
//                        .body1
//                        .copyWith(fontWeight: FontWeight.bold),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
        ],
      ),
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
