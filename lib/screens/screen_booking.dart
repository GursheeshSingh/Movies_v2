import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movies_v2/components/animated_counter.dart';
import 'package:movies_v2/models/Seat.dart';
import 'package:movies_v2/theme/constants.dart';
import 'package:movies_v2/theme/my_flutter_app_icons.dart';
import 'package:video_player/video_player.dart';

class ScreenBooking extends StatefulWidget {
  @override
  _ScreenBookingState createState() => _ScreenBookingState();
}

class _ScreenBookingState extends State<ScreenBooking>
    with TickerProviderStateMixin {

  List<Seat> _seatingPlan;
  static const seatPrice = 1.2;
  int _bookedSeats = 0;

  VideoPlayerController _controller;

  AnimationController _animationController;
  Animation _angleAnimation;

  @override
  void initState() {
    super.initState();

    _seatingPlan = _buildSeatingPlan();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 2,
        ))
      ..addListener(() {
        setState(() {});
      });

    _angleAnimation = Tween(begin: 0, end: pi / 2.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInCubic),
    );

    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();

        Future.delayed(Duration(seconds: 2), () {
          print('Starting animation');
          _animationController.forward();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'blackBox',
            createRectTween: _createRectTween,
            child: Container(
              color: Colors.black,
              width: mediaQuery.size.width,
              height: mediaQuery.size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Center(
                        child: _controller.value.initialized
                            ? Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.003)
                                  ..rotateX(_animationController.value),
                                alignment: Alignment.center,
                                child: _buildScreen(),
                              )
                            : Container(
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.black,
                      child: _buildSeatsGrid(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildAllStatus(),
                        SizedBox(
                          height: 30,
                        ),
                        _buildTimings()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAppbar(),
          _buildPayButton(context)
        ],
      ),
    );
  }

  static RectTween _createRectTween(Rect begin, Rect end) {
    return QuadraticOffsetTween(begin: begin, end: end);
  }

  _buildScreen() {
    return ClipRect(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  _buildAllStatus() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildSeatStatus(kCoolLightGray, 'Available'),
          _buildSeatStatus(kCoolGray, 'Taken'),
          _buildSeatStatus(kCoolOrange, 'Selected'),
        ],
      ),
    );
  }

  _buildSeatStatus(Color color, String statusType) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: color,
          radius: 5,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          statusType,
          style: kMyNormalTextStyle,
        )
      ],
    );
  }

  _buildSeatingPlan() {
    int numberOfSeats = 84;
    return List.generate(numberOfSeats, (index) {
      int row = (index ~/ 12) + 1;
      int column = (index % 12) + 1;
      if (column > 10) {
        return Seat(row: row, column: column, seatStatus: Status.BOOKED);
      } else if (column == 10) {
        return Seat(row: row, column: column, seatStatus: Status.NO_SEAT);
      } else if (row == 2 || row == 3 || row == 5) {
        return Seat(row: row, column: column, seatStatus: Status.BOOKED);
      } else {
        return Seat(row: row, column: column, seatStatus: Status.AVAILABLE);
      }
    });
  }

  _buildSeatsGrid() {
    return GridView.count(
      padding: EdgeInsets.all(8),
      crossAxisCount: 12,
      children: List.generate(_seatingPlan.length, (index) {
        int row = (index ~/ 12) + 1;
        int column = (index % 12) + 1;
        Seat seat = _seatingPlan[index];
        if (seat.seatStatus == Status.AVAILABLE) {
          return _buildIcon(kCoolLightGray, seat);
        } else if (seat.seatStatus == Status.BOOKED) {
          return _buildIcon(kCoolGray, seat);
        } else if (seat.seatStatus == Status.SELECTED) {
          return _buildIcon(kCoolOrange, seat);
        } else {
          return Container();
        }
      }),
    );
  }

  _buildIcon(Color color, Seat seat) {
    return InkWell(
      onTap: () {
        if (seat.seatStatus == Status.AVAILABLE) {
          setState(() {
            seat.seatStatus = Status.SELECTED;
            _bookedSeats += 1;
          });
        } else if (seat.seatStatus == Status.SELECTED) {
          setState(() {
            seat.seatStatus = Status.AVAILABLE;
            _bookedSeats -= 1;
          });
        }
      },
      child: Icon(
        MyFlutterApp.bus,
        color: color,
        size: 35,
      ),
    );
  }

  _buildAppbar() {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: CloseButton(),
        ),
      ),
    );
  }

  _buildPayButton(_) {
    final MediaQueryData mediaQuery = MediaQuery.of(_);

    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.all(8),
        child: Container(
          width: mediaQuery.size.width - 100,
          decoration: BoxDecoration(
            color: kCoolOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    'PAY',
                    textAlign: TextAlign.center,
                    style: kMyTextStyle,
                  ),
                ),
                AnimatedCount(
                  count: _bookedSeats * seatPrice,
                  duration: Duration(milliseconds: 500),
                  textStyle: kMyTextStyle,
                  prefix: "\$",
                )
              ],
            ),
          ),
        ));
  }

  _buildTimings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTimingWidget('17:30', kCoolOrange),
        SizedBox(
          width: 10,
        ),
        _buildTimingWidget('18:00', Colors.black),
        SizedBox(
          width: 10,
        ),
        _buildTimingWidget('18:30', Colors.black),
      ],
    );
  }

  _buildTimingWidget(String timing, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: kCoolGray, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        timing,
        style: kMyNormalTextStyle,
      ),
    );
  }
}

class QuadraticOffsetTween extends RectTween {
  QuadraticOffsetTween({Rect begin, Rect end})
      : super(begin: begin, end: end) {}

  @override
  Rect lerp(double t) {

    final Offset center = MaterialPointArcTween(
      begin: begin.center,
      end: end.center,
    ).lerp(t);

    final double width = lerpDouble(begin.width, end.width, t);
    var dx = begin.left + (begin.width / 2);
    var dy = begin.top + (begin.height / 2);
    return Rect.fromCircle(center: Offset(dx, dy), radius: width * 1.75);
  }
}
