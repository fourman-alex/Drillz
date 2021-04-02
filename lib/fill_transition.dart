import 'package:flutter/material.dart';

class FillTransition extends StatelessWidget {
  FillTransition({
    Key? key,
    // TODO(alex): there should be an easier way to calculate the sorce documented here. maybe add a utility method or convert this to statefull and calculate it yourslef
    required this.source,
    required this.child,
    required Color fromColor,
    required Color toColor,
    required BorderRadius fromBorderRadius,
    // TODO(alex): toBorderRadius should default to a square
    required BorderRadius toBorderRadius,
  })  : colorTween = ColorTween(begin: fromColor, end: toColor),
        _borderRadiusTween = BorderRadiusTween(
          begin: fromBorderRadius,
          end: toBorderRadius,
        ),
        assert(source != null),
        assert(child != null),
        super(key: key);

  final Rect source;
  final Widget child;
  final ColorTween colorTween;
  final BorderRadiusTween _borderRadiusTween;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = ModalRoute.of(context)!.animation!;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Animation<double> positionAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(0.1, 0.75, curve: Curves.easeInOutSine),
        );

        final Animation<RelativeRect> itemPosition = RelativeRectTween(
          begin: RelativeRect.fromLTRB(
              source.left,
              source.top,
              constraints.biggest.width - source.right,
              constraints.biggest.height - source.bottom),
          end: RelativeRect.fill,
        ).animate(positionAnimation);

        final Animation<double> materialFadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(0.0, 0.1),
        );

        final Animation<double> fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(0.75, 1.0),
        );

        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              child: child,
              animation: animation,
              builder: (_, Widget? child) {
                return Positioned.fromRelativeRect(
                  rect: itemPosition.value,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Opacity(
                        opacity: materialFadeAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                _borderRadiusTween.evaluate(animation),
                            color: colorTween.evaluate(animation),
                          ),
                        ),
                      ),
                      Opacity(
                        child: child,
                        opacity: fadeAnimation.value,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
