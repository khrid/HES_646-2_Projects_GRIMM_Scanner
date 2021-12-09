import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/widgets/custom_field_widget.dart';

import 'edit_item.dart';

class CreateItemScreen extends StatefulWidget {
  static const routeName = '/create_item';

  const CreateItemScreen({Key? key}) : super(key: key);

  @override
  _CreateItemState createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItemScreen> {
  final _key = GlobalKey<FormState>();
  var _customFields = <Widget>[];
  TextEditingController descriptionController =
      TextEditingController(); // controlleur de la description
  TextEditingController locationController =
      TextEditingController(); // controlleur du email
  TextEditingController colorController =
      TextEditingController(); //Controller de la color
  TextEditingController categorieController =
      TextEditingController(); // controlleur de la catégorie
  TextEditingController remarkController =
      TextEditingController(); // controlleur de la remarque

  String dropdownValue = "Non défini";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GrimmItem grimmItem = GrimmItem(
        description: "description",
        location: "location",
        color: "color",
        idCategory: "idCategory",
        available: true,
        remark: "remark");

    //print("ItemDetail - GrimmItem - " + grimmItem.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_item_creation')!),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(50),
          children: <Widget>[
            Text(
              getTranslated(context, 'title_item_creation')!,
              style: const TextStyle(
                fontFamily: "Raleway-Regular",
                fontSize: 30.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getTranslated(context, 'error_name_item_empty')!;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: getTranslated(context, 'item_name')!,
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
              ),
              textInputAction: TextInputAction.next,
              cursorColor: Theme.of(context).backgroundColor,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: locationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getTranslated(context, 'error_location_item_empty')!;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: getTranslated(context, 'item_location')!,
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
              ),
              textInputAction: TextInputAction.next,
              cursorColor: Theme.of(context).backgroundColor,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: colorController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getTranslated(context, 'error_color_item_empty')!;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: getTranslated(context, 'color')!,
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
              ),
              textInputAction: TextInputAction.next,
              cursorColor: Theme.of(context).backgroundColor,
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('category')
                  .orderBy("name")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
                  // encore plus loin pour être sûr
                  // si on a des données et que le doc existe
                  if (snapshot.data != null) {
                    List<String> categories = [];

                    snapshot.data!.docs.forEach((result) {
                      categories.add(result['name']);
                    });
                    return DropdownButtonFormField<String>(
                      value: dropdownValue,
                      hint: Text(getTranslated(context, 'category')!),
                      decoration: InputDecoration(
                        labelText: getTranslated(context, 'category')!,
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      iconSize: 24,
                      //elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    );
                  }
                }
                return const Text("");
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: remarkController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getTranslated(context, 'error_remark_item_empty')!;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: getTranslated(context, 'remark')!,
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
              ),
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: _customFields,
              ),
            ),
             const SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            side: const BorderSide(
                                width: 1.0, color: Colors.black),
                          ),
                          onPressed: () {
                            print("click");
                            setState(() {
                              _customFields.add(CustomFieldWidget(
                                  customFieldKey: "", customFieldValue: ""));
                            });
                          },
                          child: Text(
                              getTranslated(context, 'button_add_field')!)),
                      const Spacer(),
                      getRemoveCustomFieldButton()
                    ],
                  )
                ],
              ),
            ),
             const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(
                      fontFamily: "Raleway-Regular", fontSize: 14.0),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  padding: const EdgeInsets.all(20.0),
                ),
                onPressed: () async {
                  {
                    if (_key.currentState!.validate()) {
                      GrimmItem item = GrimmItem(
                          description: descriptionController.text,
                          location: locationController.text,
                          color: colorController.text,
                          remark: remarkController.text,
                          idCategory: await getIdForCategoryName(dropdownValue),
                          available: true);
                      // si on a un champ personnalisé
                      if (_customFields.isNotEmpty) {
                        for (var element in _customFields) {
                          item.addCustomField(
                              (element as CustomFieldWidget)
                                  .customFieldKey
                                  .toString(),
                              (element).customFieldValue.toString());
                        }
                      }
                      print(item);
                      await item.saveToFirestore();
                      //print("Item CREATE" + item.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(getTranslated(
                              context, 'snackbar_item_create_success')!)));
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text(getTranslated(context, 'button_validate')!)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget getRemoveCustomFieldButton() {
    if (_customFields.isNotEmpty) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            side: const BorderSide(width: 1.0, color: Colors.black),
          ),
          onPressed: () {
            print("click");
            setState(() {
              _customFields.removeLast();
            });
          },
          child: Text(getTranslated(context, 'button_delete_field')!));
    }
    return const SizedBox(width: 0, height: 0);
  }
}
