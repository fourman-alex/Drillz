import 'package:flutter/material.dart';

class FillTransition extends StatelessWidget {
  FillTransition({
    Key key,
    @required this.source,
    @required this.child,
    Color fromColor,
    Color toColor,
  })  : colorTween = (fromColor != null && toColor != null)
            ? ColorTween(begin: fromColor, end: toColor)
            : null,
        assert(source != null),
        assert(child != null),
        super(key: key);

  final Rect source;
  final Widget child;
  final ColorTween colorTween;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = ModalRoute.of(context).animation;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Animation<double> positionAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        );

        final Animation<RelativeRect> itemPosition = RelativeRectTween(
          begin: RelativeRect.fromLTRB(
              source.left,
              source.top,
              constraints.biggest.width - source.right,
              constraints.biggest.height - source.bottom),
          end: RelativeRect.fill,
        ).animate(positionAnimation);

        final Animation<double> fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );

        return Stack(
          children: <Widget>[
            PositionedTransition(
              rect: itemPosition,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  if (colorTween != null)
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) =>
                          Material(color: colorTween.evaluate(animation)),
                    )
                  else
                    Material(),
                  FadeTransition(
                    child: SafeArea(child: child),
                    opacity: fadeAnimation,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
