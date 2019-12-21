import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_v2/constants.dart';
import 'package:movies_v2/widgets/actor_widget.dart';
import 'package:movies_v2/widgets/buy_button.dart';
import 'package:movies_v2/widgets/genre_widget.dart';
import 'package:movies_v2/widgets/movie_title.dart';
import 'package:movies_v2/widgets/rating_bar.dart';

import 'home_page_2.dart';

class PageItem extends StatefulWidget {
  final int num;
  String _movieName;
  String _moviePath;

  PageItem({Key key, this.num}) : super(key: key) {
    _movieName = movies[num].movieName;
    _moviePath = movies[num].moviePath;
  }

  @override
  _PageItemState createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AnimationController _controller;
  Animation _scaleAnimation;

  AppBar _appBar = AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    leading: IconTheme(
      data: IconThemeData(color: Colors.white),
      child: CloseButton(),
    ),
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: prefix0.Duration(
        seconds: 2,
      ),
    );

    _scaleAnimation = Tween(begin: 1.0, end: 2.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildMoviePoster(),
          Container(
            margin: EdgeInsets.only(
              top: mediaQuery.padding.top + _appBar.preferredSize.height + 50,
            ),
            child: _buildCard(),
          ),
          _buildAppbar(),
          _buildBuyTicketButton(),
        ],
      ),
    );
  }

  bool _onCardContentScrolled(Notification _) {
    if (_ is ScrollUpdateNotification) {
      double distance = _scrollController.position.pixels;
      if (distance < 0) {
        double scaleFactor = distance.abs() / 75;
        scaleFactor = scaleFactor > 2 ? 2 : scaleFactor;
        scaleFactor /= 2;
        _controller.value = scaleFactor;
      }
      return true;
    }
    return false;
  }

  _buildMoviePoster() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          width: 175,
          child: Image.asset('images/poster1.jpg'),
        ),
      ),
    );
  }

  _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: NotificationListener(
        onNotification: _onCardContentScrolled,
        child: _buildCardContent(),
      ),
    );
  }

  _buildCardContent() {
    return ListView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        MovieTitle(num: widget.num, movieName: widget._movieName),
        _buildGenreRow(widget.num),
        _buildRatingRow(widget.num),
        _buildDirector(),
        SizedBox(
          height: 25,
        ),
        _buildActors(),
        _buildIntroduction()
      ],
    );
  }

  _buildAppbar() {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: _appBar,
    );
  }

  _buildDirector() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(4),
      child: Text(
        'Director/Todd Phillips',
        style: TextStyle(
          color: kCoolGray,
          fontSize: 12,
        ),
      ),
    );
  }

  _buildActors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            'Actors',
            style: TextStyle(
              color: kCoolGray,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            new ActorWidget(
              actorImage: 'images/actor5.jpg',
              actorName: 'Joaquin Phoenix',
            ),
            new ActorWidget(
              actorImage: 'images/actor6.jpg',
              actorName: 'Robert De Niro',
            ),
            new ActorWidget(
              actorImage: 'images/actor4.jpg',
              actorName: 'Zazie Beetz',
            )
          ],
        )
      ],
    );
  }

  _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            'Introduction',
            style: TextStyle(
              color: kCoolGray,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            'Joker is a 2019 American psychological thriller film directed and produced by Todd Phillips, who co-wrote the screenplay with Scott Silver. The film, based on DC Comics characters, stars Joaquin Phoenix as the Joker. Joker provides a possible origin story for the character; set in 1981, it follows Arthur Fleck, a failed stand-up comedian whose descent into insanity and nihilism inspires a violent countercultural revolution against the wealthy in a decaying Gotham City. Robert De Niro, Zazie Beetz, Frances Conroy, Brett Cullen, Glenn Fleshler, Bill Camp, Shea Whigham, and Marc Maron appear in supporting roles. Joker was produced by Warner Bros. Pictures, DC Films, and Joint Effort, in association with Bron Creative and Village Roadshow Pictures, and distributed by Warner Bros.Phillips conceived Joker in 2016 and wrote the script with Silver throughout 2017. The two were inspired by 1970s character studies and the films of Martin Scorsese (particularly Taxi Driver and The King of Comedy), who was initially attached to the project as a producer. The graphic novel Batman: The Killing Joke (1988) was the basis for the premise, but Phillips and Silver otherwise did not look to specific comics for inspiration. Phoenix became attached in February 2018 and was cast that July, while the majority of the cast signed on by August. Principal photography took place in New York City, Jersey City, and Newark, from September to December 2018. Joker is the first live-action theatrical Batman film to receive an R-rating from the Motion Picture Association of America, due to its violent and disturbing content. ',
            style: TextStyle(
              color: kCoolLightGray,
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  _buildGenreRow(int num) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new GenreWidget(
          genreType: 'Action',
          num: 1,
          index: num,
        ),
        new GenreWidget(
          genreType: 'Drama',
          num: 2,
          index: num,
        ),
        new GenreWidget(
          genreType: 'History',
          num: 3,
          index: num,
        )
      ],
    );
  }

  _buildRatingRow(int index) {
    prefix0.print(index.toString());
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'ratingText$index',
            child: Text(
              '9.0',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          RatingBar(
            rating: 4,
            size: 16.0,
            num: index,
          ),
        ],
      ),
    );
  }

  _buildBuyTicketButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(8),
      child: BuyButton(
        onPressed: () {
        },
      ),
    );
  }
}
