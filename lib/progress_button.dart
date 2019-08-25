import 'dart:math' as Math;

import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  final Duration duration;
  final double width;
  final double height;
  final Color color;
  final Color startColor;
  final Color endColor;
  final Text text;
  final void Function() onPressCompleted;

  const ProgressButton({
    Key key,
    this.text,
    this.width,
    this.height,
    this.duration = const Duration(seconds: 2),
    @required this.onPressCompleted,
    @required this.color,
    this.startColor,
    this.endColor,
  }) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with SingleTickerProviderStateMixin<ProgressButton> {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) widget.onPressCompleted();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InnerProgressButton(
      width: widget.width,
      height: widget.height,
      animationController: _animationController,
      color: widget.color,
      endColor: widget.endColor,
      startColor: widget.startColor,
      text: widget.text,
    );
  }
}

class _InnerProgressButton extends AnimatedWidget {
  final AnimationController animationController;
  final double width;
  final double height;
  final Color startColor;
  final Color endColor;
  final Color color;
  final Text text;

  _InnerProgressButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.animationController,
    @required this.color,
    @required this.startColor,
    @required this.endColor,
    @required this.text,
  }) : super(key: key, listenable: animationController);

  @override
  Widget build(BuildContext context) {
    var strokeWidth = Math.max(height, width) / 10;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerCancel: (details) {
        debugPrint("onPointerCancel");
        animationController.reset();
      },
      onPointerMove: (details) {
        //check if the pointer is outside of the button boundaries
        // this does ignore it being circular
        final RenderBox box = context.findRenderObject();
        if (details.localPosition.dx > box.size.width ||
            details.localPosition.dy > box.size.height ||
            details.localPosition.dx < 0 ||
            details.localPosition.dy < 0) animationController.reset();
      },
      onPointerDown: (details) {
        debugPrint(details.toString());
        animationController.forward();
      },
      onPointerUp: (details) {
        debugPrint(details.toString());
        if (animationController.status == AnimationStatus.completed)
          debugPrint("animation completed at tap up");
        else
          animationController.reset();
      },
      child: SizedBox(
        height: height,
        width: width,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Material(
            elevation: 4.0,
            type: MaterialType.circle,
            color: color,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(strokeWidth / 2),
                  child: SizedBox.expand(
                    child: CircularProgressIndicator(
                      strokeWidth: strokeWidth,
                      valueColor: ColorTween(begin: startColor, end: endColor)
                          .animate(animationController),
                      value: animationController.value,
                    ),
                  ),
                ),
                Align(
                  child: SizedBox.expand(
                    child: Padding(
                      padding: EdgeInsets.all(strokeWidth),
                      child: FittedBox(
                        child: text,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
