import 'package:flutter/material.dart';

class MoodIcon extends StatelessWidget {
  String image;
  String name;
  Color colour;
  MoodIcon({required this.name, required this.image, required this.colour});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            height: 45,
            width: 45,
          ),
          Text(name)
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(color: colour),
      ),
      height: 35,
      width: 75,
    );
  }
}
