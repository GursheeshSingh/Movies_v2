import 'package:flutter/material.dart';

class ActorWidget extends StatelessWidget {
  final String actorImage;
  final String actorName;

  const ActorWidget({this.actorImage, this.actorName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          height: 100,
          width: 100,
          child: ClipRRect(
            child: Image.asset(
              actorImage,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Text(actorName)
      ],
    );
  }
}
