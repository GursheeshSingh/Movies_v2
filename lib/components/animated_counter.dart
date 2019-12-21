import 'package:flutter/material.dart';

class AnimatedCount extends ImplicitlyAnimatedWidget {
  AnimatedCount(
      {Key key,
      @required this.count,
      @required Duration duration,
      Curve curve = Curves.linear,
      this.textStyle,
      this.prefix})
      : super(duration: duration, curve: curve, key: key);

  final TextStyle textStyle;
  final num count;
  final String prefix;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedCountState();
  }
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _intCount;
  Tween<double> _doubleCount;

  @override
  Widget build(BuildContext context) {
    return widget.count is int
        ? Text(
            (widget.prefix ?? "") + _intCount.evaluate(animation).toString(),
            style: widget.textStyle,
          )
        : Text(
            (widget.prefix ?? "") +
                _doubleCount.evaluate(animation).toStringAsFixed(1),
            style: widget.textStyle);
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    if (widget.count is int) {
      _intCount = visitor(
        _intCount,
        widget.count,
        (dynamic value) => IntTween(begin: value),
      );
    } else {
      _doubleCount = visitor(
        _doubleCount,
        widget.count,
        (dynamic value) => Tween<double>(begin: value),
      );
    }
  }
}
