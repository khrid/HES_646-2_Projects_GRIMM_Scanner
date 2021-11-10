import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardHistory extends StatelessWidget {
  const CardHistory({Key? key, required this.borrowText, required this.returnText})
      : super(key: key);
  final Widget borrowText;
  final Widget returnText;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.north_east,
                      color: Colors.red,
                      size: 32,
                    ),
                    const Text(
                      "Emprunt",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    borrowText
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.south_east,
                      color: Colors.green,
                      size: 32,
                    ),
                    const Text(
                      "Retour",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    returnText
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            )));
  }
}