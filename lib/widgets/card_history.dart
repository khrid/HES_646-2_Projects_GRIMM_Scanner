import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';

class CardHistory extends StatelessWidget {
  const CardHistory(
      {Key? key, required this.borrowText, required this.returnText})
      : super(key: key);
  final Widget borrowText;
  final Widget returnText;

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      getTranslated(context, 'borrow')!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    Text(
                      getTranslated(context, 'return')!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
