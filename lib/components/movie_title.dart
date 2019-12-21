import 'package:flutter/material.dart';
import 'package:movies_v2/theme/constants.dart';

class MovieTitle extends StatelessWidget {
  const MovieTitle({
    Key key,
    @required this.num,
    @required String movieName,
  })  : _movieName = movieName,
        super(key: key);

  final int num;
  final String _movieName;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "text$num",
      child: Text(
        _movieName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: kCoolGray2,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
