import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  var icon, size, color, borderColor, height, width;
  CardButton(
      {Key? key, this.icon,
      this.size,
      this.color,
      this.borderColor,
      this.height,
      this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: borderColor,
              blurRadius: 10.0,
              offset: const Offset(0, 8.0),
            ),
          ]),
      margin: const EdgeInsets.all(5.0),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
