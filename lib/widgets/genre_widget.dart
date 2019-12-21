
import 'package:flutter/material.dart';

import '../constants.dart';

class GenreWidget extends StatelessWidget {
  final String genreType;
  final int num;
  final int index;

  const GenreWidget({@required this.genreType, this.num, this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'genre$index$num',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kCoolLightGray, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        margin: EdgeInsets.all(4),
        child: Text(
          '$genreType',
          style: TextStyle(
            fontSize: 10,
            color: kCoolLightGray,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
