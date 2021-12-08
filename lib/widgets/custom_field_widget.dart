import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFieldWidget extends StatefulWidget {
  late String customFieldKey;
  late String customFieldValue;

  CustomFieldWidget({Key? key,
    required String customFieldKey,
    required String customFieldValue
  }) : this.customFieldKey = customFieldKey, this.customFieldValue = customFieldValue, super(key: key);

  CustomFieldWidgetState createState() => new CustomFieldWidgetState();
}

class CustomFieldWidgetState extends State<CustomFieldWidget> {
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 5,
                child: TextFormField(
                  initialValue: widget.customFieldKey,
                  onChanged: (string) {
                    setState(() {
                      widget.customFieldKey = string;
                    });
                  },
                    decoration: const InputDecoration(
                      labelText: 'Libellé',
                      labelStyle: TextStyle(
                        fontFamily: "Raleway-Regular",
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ))),
            Spacer(
              flex: 1,
            ),
            Expanded(
                flex: 10,
                child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    initialValue: widget.customFieldValue,
                    onChanged: (string) {
                      setState(() {
                        widget.customFieldValue = string;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Valeur',
                      labelStyle: TextStyle(
                        fontFamily: "Raleway-Regular",
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ))),

          ],
        ),
      ],
    );
  }
}
