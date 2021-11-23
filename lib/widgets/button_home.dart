import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHomeButton extends StatelessWidget {
  CustomHomeButton({Key? key, required this.title, this.onPressed})
      : super(key: key);
  final String title;
  var onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onPressed,
      child: //Text(title.toUpperCase(), textAlign: TextAlign.center),
          FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.black,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        side: const BorderSide(width: 1.0, color: Colors.black),
        fixedSize: const Size(250, 100),
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }
}
