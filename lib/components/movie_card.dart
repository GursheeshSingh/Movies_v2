import 'package:flutter/material.dart';
import 'package:movies_v2/components/rating_bar.dart';

import 'genre_widget.dart';
import 'movie_title.dart';

class MovieCardContent extends StatelessWidget {
  final String moviePath;
  final String movieName;
  final int number;

  const MovieCardContent({this.moviePath, this.movieName, this.number});

  _buildGenreRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new GenreWidget(
          genreType: 'Action',
          num: 1,
          index: number,
        ),
        new GenreWidget(
          genreType: 'Drama',
          num: 2,
          index: number,
        ),
        new GenreWidget(
          genreType: 'History',
          num: 3,
          index: number,
        )
      ],
    );
  }

  _buildRatingRow() {
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'ratingText$number',
            child: Text(
              '9.0',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          RatingBar(
            rating: 4,
            size: 16.0,
            num: number,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                child: Image.asset(
                  moviePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          MovieTitle(num: number, movieName: movieName),
          _buildGenreRow(),
          _buildRatingRow(),
          Icon(Icons.more_horiz),
          SizedBox(
            height: 75,
          )
        ],
      ),
    );
  }
}
