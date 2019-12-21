import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_v2/constants.dart';

class RatingBar extends StatelessWidget {
  final rating;
  final size;
  final num;

  const RatingBar({
    this.rating,
    this.size,
    this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: List.generate(5, (index) {
          return Hero(
            tag: 'ratingStar$num$index',
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: kCoolOrange2,
              size: size,
            ),
            createRectTween: (_, __) {
              return _createRectTween(_, __, index);
            },
            /*            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              final Hero toHero = toHeroContext.widget;
              return ScaleTransition(
                scale: animation.drive(
                  Tween<double>(begin: 0.0, end: 1.0).chain(
                    CurveTween(
                      curve: Interval(0.0, 1.0, curve: PeakQuadraticCurve()),
                    ),
                  ),
                ),
                child: toHero.child,
              );
            }*/
          );
        }),
      ),
    );
  }

  static RectTween _createRectTween(Rect begin, Rect end, int index) {
    switch (index) {
      case 0:
        return QuadraticOffsetTween(
            begin: begin, end: end, cubic: Cubic(0.19, 1.0, 0.22, 1.0));
      case 1:
        return QuadraticOffsetTween(
            begin: begin, end: end, cubic: Cubic(0.23, 1.0, 0.32, 1.0));
      case 2:
        return QuadraticOffsetTween(
            begin: begin, end: end, cubic: Cubic(0.165, 0.84, 0.44, 1.0));
      case 3:
        return QuadraticOffsetTween(
            begin: begin, end: end, cubic: Cubic(0.215, 0.61, 0.355, 1.0));
      case 4:
        return QuadraticOffsetTween(
            begin: begin, end: end, cubic: Cubic(0.25, 0.46, 0.45, 0.94));
    }
  }
}

class QuadraticOffsetTween extends RectTween {
  QuadraticOffsetTween({Rect begin, Rect end, Cubic cubic})
      : super(begin: begin, end: end) {
    _yCubic = cubic;
    print(begin.left);
  }

  Cubic _xCubic = Cubic(0, 0.5, 0.5, 1);

  Cubic _yCubic;

  @override
  Rect lerp(double t) {
    assert(_xCubic != null);
//    print(begin.top);
//    print(begin.left);
//    print(end.top);
//    print(end.left);

//    easeOutExpo
//    Cubic cubic = Cubic(0.19, 1.0, 0.22, 1.0);
//    easeInOutBack
//    Cubic cubic = Cubic(0.68, -0.55, 0.265, 1.55);

    var xTransformed = _xCubic.transform(t);
    var yTransformed = _yCubic.transform(t);
    double height = end.top - begin.top;
    double width = end.left - begin.left;
/*
    double period = 1.0;

  easeInOutCurve
    final double x = -11 * begin.width * pow(t, 2) +
        (end.width + 10 * begin.width) * t +
        begin.width;
    final double y = -2 * begin.height * pow(t, 2) +
        (end.height + 1 * begin.height) * t +
        begin.height;

    final double s = period / 4.0;
    t = 2.0 * t - 1.0;
    double val;
    if (t < 0.0) {
      val = (-0.5 * pow(2.0, 10.0 * t) * sin((t - s) * (pi * 2.0) / period));
    } else {
      val = (pow(2.0, -10.0 * t) * sin((t - s) * (pi * 2.0) / period) * 0.5 +
          1.0);
    }
//    double animatedY = begin.top + (val * width);

*/

    double animatedX = begin.left + (xTransformed * width);
    double animatedY = begin.top + (yTransformed * height);
    print((xTransformed * width));
//    print((begin.left));
    return Rect.fromLTWH(animatedX, animatedY, 1, 1);
//    return Rect.fromPoints(x, y);
  }
}

class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return 4 * pow(t - 0.5, 2);
  }
}

class PeakQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return -15 * pow(t, 2) + 15 * t + 1;
  }
}
