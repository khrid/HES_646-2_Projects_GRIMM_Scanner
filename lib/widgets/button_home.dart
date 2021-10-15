import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHomeButton extends StatelessWidget {
  CustomHomeButton({Key? key, required this.title, this.onPressed}) : super(key: key);
  String title;
  var onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
      style: ElevatedButton.styleFrom(
        side: const BorderSide(width: 2.0, color: Colors.black),
        fixedSize: const Size(275, 125),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 28.0
        )
      ),

    );
  }
}
