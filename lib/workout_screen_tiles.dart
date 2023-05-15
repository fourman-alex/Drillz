import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'audio.dart';
import 'consts.dart';

class StartTile extends StatelessWidget {
  const StartTile({required VoidCallback onPressed, Key? key})
      : _onPressed = onPressed,
        super(key: key);

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
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontFamily: Consts.righteousFont,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class FinishTile extends StatelessWidget {
  const FinishTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'End',
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontFamily: Consts.righteousFont),
        ),
      ),
    );
  }
}

class WorkTile extends StatelessWidget {
  const WorkTile({required int reps, required VoidCallback onPressed, Key? key})
      : _onPressed = onPressed,
        _amount = reps,
        super(key: key);

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
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontFamily: Consts.righteousFont,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
          Center(
            child: Text(
              '$_amount',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontFamily: Consts.righteousFont,
                    color: Theme.of(context).colorScheme.primary,
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
  const RestTile({
    required this.duration,
    required VoidCallback onDone,
    Key? key,
  })  : _onDone = onDone,
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick > duration) {
        audioPlayer.resume();
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
            duration: const Duration(milliseconds: 750),
            color: Theme.of(context).colorScheme.primaryContainer,
            height: _progressBarHeight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 180),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'REST',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontFamily: Consts.righteousFont,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
        Align(
          child: Text(
            _timerString.toString(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontFamily: Consts.righteousFont,
                color: Theme.of(context).colorScheme.primary),
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
