import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movies_v2/screens/screen_booking.dart';

import '../theme/constants.dart';

class BuyButton extends StatefulWidget {
  final Function onPressed;

  BuyButton({
    this.onPressed,
  });

  @override
  _BuyButtonState createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> with TickerProviderStateMixin {
  String _buttonText = 'BUY TICKET';

  AnimationController _controller;
  Animation _roundnessAnimation;
  Animation _widthAnimation;

  AnimationController _controller2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    )..addListener(() {
        setState(() {});
      });

    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    )..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ScreenBooking();
          }),
        );
      }
    });

    _roundnessAnimation = Tween(begin: 10.0, end: 25.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _widthAnimation = Tween(begin: 250.0, end: 40.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (widget.onPressed != null) {
            setState(() {
              _buttonText = '';
            });
            _controller.forward();
          }
        },
        child: Hero(
          tag: 'blackBox',
          flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, widget) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                );
              },
              child: toHeroContext.widget,
            );
          },
          child: Container(
            width: _widthAnimation.value,
            decoration: BoxDecoration(
              color: kCoolGray,
              borderRadius: BorderRadius.circular(_roundnessAnimation.value),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//topRight: Radius.circular(50),
//topLeft: Radius.circular(50),
//bottomRight: Radius.circular(50),
//bottomLeft: Radius.circular(50),
