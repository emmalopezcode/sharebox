import 'package:flutter/material.dart';
import 'package:share_box/misc/data.dart';


class SlimButton extends StatelessWidget {
  
  final String text;
  final Color color;
  final Function action;
  SlimButton({this.text, this.color, this.action});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: color,
        padding: EdgeInsets.all(4),
        child: GestureDetector(
          onTap: action,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            )),
        ),
      ),
    );
  }
}