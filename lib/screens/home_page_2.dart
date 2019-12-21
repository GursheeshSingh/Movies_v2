import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movies_v2/constants.dart';
import 'package:movies_v2/model/movie_data.dart';
import 'package:movies_v2/screens/page_item.dart' as prefix0;
import 'package:movies_v2/widgets/background_images.dart';
import 'package:movies_v2/widgets/buy_button.dart';
import 'package:movies_v2/widgets/genre_widget.dart';
import 'package:movies_v2/widgets/movie_card.dart';
import 'package:movies_v2/widgets/movie_title.dart';
import 'package:movies_v2/widgets/rating_bar.dart';

import '../main.dart';

final List<Movie> movies = [
  Movie(movieName: 'Good Boys', moviePath: 'images/good_boys.jpg'),
  Movie(movieName: 'Joker', moviePath: 'images/poster1.jpg'),
  Movie(movieName: 'Hustle', moviePath: 'images/hustle.jpg'),
];

class MyHomePage2 extends StatefulWidget {
  static const NonActivePageFraction = 0.7;

  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2>
    with TickerProviderStateMixin {
  final List<int> pages = List.generate(3, (index) => index);

  final _pageController = PageController(viewportFraction: 0.8);

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

//  double startPoint;

/*
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragStart: (_){
           RenderBox renderObject = _imageKey.currentContext.findRenderObject();
          _imageWidth = renderObject.size.width;
//          prefix0.print(_imageWidth);
//          print(_.globalPosition);
          startPoint = _.globalPosition.dx;
//          double viewWidth = _.globalPosition.dx;
//          _animationController.value = viewWidth / _imageWidth;
        },
        onHorizontalDragUpdate: (_){
          double dragPoint = _.globalPosition.dx;
          double viewWidth = ((dragPoint - startPoint) * 3);
          _animationController.value = viewWidth / _imageWidth;
        },
        child: SizeTransition(
          sizeFactor: _animation,
          child: Image.asset(
            movies[0].moviePath,
            key: _imageKey,
          ),
          axis: Axis.horizontal,
          axisAlignment: -1.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animationController.forward();
        },
      ),
    );
  }
*/

  _buildBuyTicketButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(8),
      child: BuyButton(onPressed: (){

      },),
    );
  }

  _onCardClicked(int index) {
    print('Card clicked at : ' + index.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return prefix0.PageItem(num: index);
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            BackgroundImages(
              movies: movies,
              pageController: _pageController,
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              itemBuilder: (context, index) => _builder(index),
            ),
            _buildBuyTicketButton(),
          ],
        ),
      ),
    );
  }

  _builder(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * (1 - MyHomePage2.NonActivePageFraction)))
              .clamp(0.0, 1.0);
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * 500,
            width: Curves.easeOut.transform(value) * 450,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          _onCardClicked(index);
        },
        child: MovieCardContent(
          moviePath: movies[index].moviePath,
          movieName: movies[index].movieName,
          number: index,
        ),
      ),
    );
  }
}
