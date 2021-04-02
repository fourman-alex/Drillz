import 'dart:async';
import 'dart:ui';

import 'package:drillz/audio.dart';
import 'package:drillz/consts.dart';
import 'package:flutter/material.dart';

class StartTile extends StatelessWidget {
  const StartTile({required VoidCallback onPressed}) : _onPressed = onPressed;

  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onPressed,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'GO',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .display4!
              .copyWith(fontFamily: Consts.righteousFont),
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
        navigator.popUntil(ModalRoute.withName('/'));
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'End',
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .display4!
              .copyWith(fontFamily: Consts.righteousFont),
        ),
      ),
    );
  }
}

class WorkTile extends StatelessWidget {
  const WorkTile({required int reps, required VoidCallback onPressed})
      : _onPressed = onPressed,
        _amount = reps;

  final int _amount;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onPressed,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'PERFORM',
                style: Theme.of(context).textTheme.display1!.copyWith(
                      fontFamily: Consts.righteousFont,
                    ),
              ),
            ),
          ),
          Center(
            child: Text(
              '$_amount',
              style: Theme.of(context).textTheme.display4!.copyWith(
                fontFamily: Consts.righteousFont,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class RestTile extends StatefulWidget {
  const RestTile(
      {Key? key, required this.duration, required VoidCallback onDone})
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
  late int _timerString;

  late Timer _timer;

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
          _progressBarHeight = context.size!.height * (timer.tick / duration);
          _timerString = duration - timer.tick;
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
        Padding(
          padding: const EdgeInsets.only(top: 180),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'REST',
              style: Theme.of(context).textTheme.display1!.copyWith(
                    fontFamily: Consts.righteousFont,
                  ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            '${_timerString.toString()}',
            style: Theme.of(context)
                .textTheme
                .display4!
                .copyWith(fontFamily: Consts.righteousFont),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
