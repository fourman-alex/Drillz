import 'dart:developer';

import 'package:flutter/material.dart';

const _fabSize = 56.0;
const _borderStart = BorderRadius.all(Radius.circular(_fabSize / 2));

class FabToDialog extends StatelessWidget {
  FabToDialog({
    required this.fabChild,
    required this.dialogChild,
    Key? key,
  }) : super(key: key);

  final Widget fabChild;
  final Widget dialogChild;
  final BorderRadiusTween _borderTween =
      BorderRadiusTween(begin: _borderStart, end: BorderRadius.zero);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black54,
          pageBuilder: (context, animation, secondaryAnimation) {
            return Dialog(
              backgroundColor: Colors.black12,
              child: Material(
                color: Theme.of(context).colorScheme.secondary,
                child: Hero(
                  tag: 'new workout',
                  flightShuttleBuilder: _flightShuttleBuilder,
                  child: dialogChild,
                ),
              ),
            );
          },
        ));
      },
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: _borderStart,
        child: SizedBox(
          height: 56,
          width: 56,
          child: Hero(
            tag: 'new workout',
            child: fabChild,
          ),
        ),
      ),
    );
  }

  Widget _flightShuttleBuilder(flightContext, animation, flightDirection,
      fromHeroContext, toHeroContext) {
    final fromChild = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget
        : toHeroContext.widget;
    final toChild = flightDirection == HeroFlightDirection.push
        ? toHeroContext.widget
        : fromHeroContext.widget;
    final reverseAnimation = ReverseAnimation(animation);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        log('_borderTween.evaluate(animation):'
            '${_borderTween.evaluate(animation)}');
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: _borderTween.evaluate(animation),
          ),
          child: child,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: animation,
              child: SizedBox.expand(
                child: toChild,
              ),
            ),
          ),
          Positioned.fill(
            child: FadeTransition(
              opacity: reverseAnimation,
              child: SizedBox.expand(
                child: fromChild,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
