import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';

class CustomFieldWidget extends StatefulWidget {
  late String customFieldKey;
  late String customFieldValue;

  CustomFieldWidget(
      {Key? key,
      required String customFieldKey,
      required String customFieldValue})
      : this.customFieldKey = customFieldKey,
        this.customFieldValue = customFieldValue,
        super(key: key);

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
                    decoration: InputDecoration(
                      labelText: getTranslated(context, 'title_field')!,
                      labelStyle: const TextStyle(
                        fontFamily: "Raleway-Regular",
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ))),
            const Spacer(
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
                    decoration: InputDecoration(
                      labelText: getTranslated(context, 'value')!,
                      labelStyle: const TextStyle(
                        fontFamily: "Raleway-Regular",
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
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
