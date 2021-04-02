import 'package:flutter/material.dart';

class FillTransition extends StatelessWidget {
  FillTransition({
    // TODO(alex): there should be an easier way to calculate the sorce
    //  documented here. maybe add a utility method or convert this to
    //  statefull and calculate it yourslef
    required this.source,
    required this.child,
    required Color fromColor,
    required Color toColor,
    required BorderRadius fromBorderRadius,
    required BorderRadius toBorderRadius,
    Key? key,
  })  : colorTween = ColorTween(begin: fromColor, end: toColor),
        _borderRadiusTween = BorderRadiusTween(
          begin: fromBorderRadius,
          end: toBorderRadius,
        ),
        super(key: key);

  final Rect source;
  final Widget child;
  final ColorTween colorTween;
  final BorderRadiusTween _borderRadiusTween;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = ModalRoute.of(context)!.animation!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final Animation<double> positionAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.1, 0.75, curve: Curves.easeInOutSine),
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
          curve: const Interval(0.0, 0.1),
        );

        final Animation<double> fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.75, 1.0),
        );

        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: animation,
              builder: (_, child) {
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
                        opacity: fadeAnimation.value,
                        child: child,
                      ),
                    ],
                  ),
                );
              },
              child: child,
            ),
          ],
        );
      },
    );
  }
}
