import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({
    Key? key,
    this.child,
    required this.size,
    this.duration = const Duration(seconds: 1),
    required this.onPressCompleted,
    required this.color,
    required this.startColor,
    required this.endColor,
  }) : super(key: key);

  final Duration duration;
  final double size;
  final Color color;
  final Color startColor;
  final Color endColor;
  final Widget? child;
  final void Function() onPressCompleted;

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with SingleTickerProviderStateMixin<ProgressButton> {
  late AnimationController _animationController;

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
      size: widget.size,
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
    Key? key,
    required this.size,
    required this.animationController,
    required this.color,
    required this.startColor,
    required this.endColor,
    required this.child,
  })  : strokeWidth = size / 10,
        super(key: key, listenable: animationController);

  final AnimationController animationController;
  final double size;
  final double strokeWidth;
  final Color startColor;
  final Color endColor;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerCancel: (PointerCancelEvent details) {
        debugPrint('onPointerCancel');
        animationController.reset();
      },
      onPointerMove: (PointerMoveEvent details) {
        //check if the pointer is outside of the button boundaries
        // this does ignore it being circular
        final RenderBox box = context.findRenderObject() as RenderBox;
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
        height: size,
        width: size,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Material(
                type: MaterialType.circle,
                color: color,
                child: child,
              ),
            ),
            OverflowBox(
              minHeight: size + 22,
              maxHeight: size + 22,
              minWidth: size + 22,
              maxWidth: size + 22,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                valueColor: ColorTween(begin: startColor, end: endColor)
                    .animate(animationController),
                value: animationController.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
