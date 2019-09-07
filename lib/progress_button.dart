import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({
    Key key,
    this.child,
    this.width,
    this.height,
    this.duration = const Duration(seconds: 2),
    @required this.onPressCompleted,
    @required this.color,
    this.startColor,
    this.endColor,
  }) : super(key: key);

  final Duration duration;
  final double width;
  final double height;
  final Color color;
  final Color startColor;
  final Color endColor;
  final Widget child;
  final void Function() onPressCompleted;

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
      if (status == AnimationStatus.completed) {
        widget.onPressCompleted();
      }
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
      child: widget.child,
    );
  }
}

class _InnerProgressButton extends AnimatedWidget {
  const _InnerProgressButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.animationController,
    @required this.color,
    @required this.startColor,
    @required this.endColor,
    @required this.child,
  }) : super(key: key, listenable: animationController);

  final AnimationController animationController;
  final double width;
  final double height;
  final Color startColor;
  final Color endColor;
  final Color color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double strokeWidth = math.max(height, width) / 10;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerCancel: (PointerCancelEvent details) {
        debugPrint('onPointerCancel');
        animationController.reset();
      },
      onPointerMove: (PointerMoveEvent details) {
        //check if the pointer is outside of the button boundaries
        // this does ignore it being circular
        final RenderBox box = context.findRenderObject();
        if (details.localPosition.dx > box.size.width ||
            details.localPosition.dy > box.size.height ||
            details.localPosition.dx < 0 ||
            details.localPosition.dy < 0) {
          animationController.reset();
        }
      },
      onPointerDown: (PointerDownEvent details) {
        debugPrint(details.toString());
        animationController.forward();
      },
      onPointerUp: (PointerUpEvent details) {
        debugPrint(details.toString());
        if (animationController.status == AnimationStatus.completed)
          debugPrint('animation completed at tap up');
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
                        child: child,
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
