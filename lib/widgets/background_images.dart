
import 'package:flutter/material.dart';

import '../model/movie_data.dart';

class BackgroundImages extends StatefulWidget {
  BackgroundImages({
    @required this.movies,
    @required PageController pageController,
  }) : _pageController = pageController;

  final List<Movie> movies;
  final PageController _pageController;

  @override
  _BackgroundImagesState createState() => _BackgroundImagesState();
}

//ISSUE: If Does not stop between Changing, not shifting
class _BackgroundImagesState extends State<BackgroundImages>
    with TickerProviderStateMixin {
  AnimationController _currentAnimationController;
  AnimationController _nextAnimationController;
  Animation _currentAnimation;
  Animation _nextAnimation;

  double _previousPage = 0;
  double _currentPage = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _currentAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _currentAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _currentAnimationController, curve: Curves.linear));

    _nextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _nextAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _nextAnimationController, curve: Curves.linear));

    _currentAnimationController.value = 1;
    _nextAnimationController.value = 0;

    _initializeListener();
  }

  _initializeListener() {
    widget._pageController.addListener(() {
      if (widget._pageController.position.haveDimensions) {
        _previousPage = _currentPage;
        _currentPage = widget._pageController.page;
      }

      if (_currentPage > _previousPage) {
        print('SWIPING RIGHT');

        //Potential next page number
        int nextPageNumber;

        //CASE 1: Current page is fully visible
        if (_currentAnimation.value == 1) {
          print('CURRENT PAGE IS FULLY VISIBLE');
          nextPageNumber = _currentPage.ceil();
          //Distance between next page and current page
          //Distance decrease as we swipe right
          //Block will not be called on left swipe
          double distanceLeft = nextPageNumber - _currentPage;

          // If successfully reached to next page
          if (distanceLeft == 0) {
            //Change reached page to current page
            setState(() {
              nextPageNumber = _currentPage.ceil() + 1;
              _currentIndex = _currentPage.toInt();
            });

            _currentAnimationController.value = 1.0;
            _nextAnimationController.value = 0.0;
          } else {
            _nextAnimationController.value = 1 - distanceLeft;
          }
        } else if (_currentAnimationController.value != 0) {
          print('CURRENT PAGE IS PARTIALLY VISIBLE');
          nextPageNumber = _currentPage.ceil();

          double distanceLeft = nextPageNumber - _currentPage;

          if (_currentAnimationController.value != 0) {
            _currentAnimationController.value = 1 - distanceLeft;
          } else {
            _nextAnimationController.value = 1 - distanceLeft;
          }
        }
      } else if (_currentPage < _previousPage) {
        print('SWIPING LEFT');

        int previousPageNumber;

        //CASE 1: Current page is fully visible
        if (_currentAnimationController.value == 1) {
          print('CURRENT PAGE IS FULLY VISIBLE');

          previousPageNumber = _currentPage.floor();

          double distanceLeft = _currentPage - previousPageNumber;

          if (distanceLeft == 0) {
            setState(() {
              previousPageNumber = _currentPage.floor() - 1;
              _currentIndex = _currentPage.toInt();
            });

            _currentAnimationController.value = 1.0;
            _nextAnimationController.value = 0.0;
          } else {
            if (_nextAnimationController.value == 0) {
              _currentAnimationController.value = distanceLeft;
            } else {
              _nextAnimationController.value = distanceLeft;
            }
          }
        } else {
          print('CURRENT PAGE IS PARTIALLY VISIBLE');

          previousPageNumber = _currentPage.floor();

          double distanceLeft = _currentPage - previousPageNumber;

          if (distanceLeft == 0) {
            setState(() {
              previousPageNumber = _currentPage.floor() - 1;
              _currentIndex = _currentPage.toInt();
            });
            _currentAnimationController.value = 1.0;
            _nextAnimationController.value = 0.0;
          } else {
            _currentAnimationController.value = distanceLeft;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          widget.movies[(_currentIndex - 1) < 0 ? 0 : (_currentIndex - 1)]
              .moviePath,
          fit: BoxFit.fill,
        ),
        SizeTransition(
          sizeFactor: _currentAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1.0,
          child: Image.asset(
            widget.movies[_currentIndex].moviePath,
            fit: BoxFit.fill,
          ),
        ),
        SizeTransition(
          sizeFactor: _nextAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1.0,
          child: Image.asset(
            widget
                .movies[(_currentIndex + 1) >= widget.movies.length
                ? widget.movies.length - 1
                : (_currentIndex + 1)]
                .moviePath,
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }
}
