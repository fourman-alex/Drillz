import 'package:flutter/material.dart';

class FillTransition extends StatelessWidget {
  FillTransition({
    Key key,
    @required this.source,
    @required this.child,
    @required Color fromColor,
    @required Color toColor,
    BorderRadius fromBorderRadius,
    BorderRadius toBorderRadius,
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
    final Animation<double> animation = ModalRoute.of(context).animation;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Animation<double> positionAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(0.2, 0.7, curve: Curves.easeInOut),
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
          curve: Interval(0.0, 0.2),
        );

        final Animation<double> fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(0.7, 1.0, curve: Curves.easeInOut),
        );

        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: animation,
              builder: (_, __) {
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
                                _borderRadiusTween.evaluate(positionAnimation),
                            color: colorTween.evaluate(positionAnimation),
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
