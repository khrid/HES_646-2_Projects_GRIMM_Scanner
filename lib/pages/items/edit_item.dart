import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/pages/items/items_detail.dart';
import 'package:grimm_scanner/widgets/custom_field_widget.dart';

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit_item';

  const EditItemScreen({Key? key}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItemScreen> {
  final _key = GlobalKey<FormState>();
  var _customFields = <Widget>[];
  bool done = false;
  TextEditingController descriptionController = TextEditingController(
      text: ""); // controlleur de la description
  TextEditingController locationController =
      TextEditingController(text: ""); // controlleur du email
  TextEditingController colorController =
      TextEditingController(text: ""); // controlleur de la color
  TextEditingController categorieController = TextEditingController(
      text: ""); // controlleur de la catégorie
  TextEditingController remarkController = TextEditingController(
      text: ""); // controlleur de la remarque
  String dropdownValue = "pansement";
  String dropdownValueId = "";
  int firstLoad = 1;
  List test = [];
  late GrimmItem grimmItem;

  @override
  Widget build(BuildContext context) {
    grimmItem = (ModalRoute.of(context)!.settings.arguments == null
        ? null
        : ModalRoute.of(context)!.settings.arguments as GrimmItem)!;

    if (grimmItem is! GrimmItem) {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, ItemDetail.routeName, (Route<dynamic> route) => false));
    }

    descriptionController.text = grimmItem.description;
    locationController.text = grimmItem.location;
    colorController.text = grimmItem.color;
    categorieController.text = grimmItem.idCategory;
    remarkController.text = grimmItem.remark;

    if (!done) {
      buildCustomFields();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_item_edit')!),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: ListView(
        padding: const EdgeInsets.only(top: 20, right: 50, left: 50, bottom: 50),
          children: <Widget>[
            Text(
              getTranslated(context, 'title_item_modify')!,
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

                    for (var result in snapshot.data!.docs) {
                      categories.add(result['name']);
                      if (result.id == grimmItem.idCategory && firstLoad == 1) {
                        dropdownValue = result["name"];
                      }
                    }

                    firstLoad = 0;
                    return DropdownButtonFormField<String>(
                      value: dropdownValue,
                      hint: Text(getTranslated(context, 'category')!),
                      iconSize: 24,
                      //elevation: 16,
                      decoration: InputDecoration(
                        labelText: getTranslated(context, 'category')!,
                      ),
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
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
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
                    grimmItem.description = descriptionController.text;
                    grimmItem.location = locationController.text;
                    grimmItem.color = colorController.text;
                    grimmItem.remark = remarkController.text;
                    grimmItem.idCategory =
                        await getIdForCategoryName(dropdownValue);
                    print("End " + grimmItem.toString());
                    if (_customFields.isNotEmpty) {
                      grimmItem.customFields = {};
                      for (var element in _customFields) {
                        CustomFieldWidget widget = element as CustomFieldWidget;
                        if (element.customFieldValue.isNotEmpty &&
                            element.customFieldKey.isNotEmpty) {
                          grimmItem.addCustomField(
                              (element).customFieldKey.toString(),
                              (element).customFieldValue.toString());
                        }
                      }
                    } else {
                      grimmItem.customFields = {};
                    }
                    print(grimmItem);
                    grimmItem.updateFirestore();
                    Navigator.of(context).pop();
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

  getRemoveCustomFieldButton() {
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

  void buildCustomFields() {
    done = true;
    if (grimmItem.customFields!.isNotEmpty) {
      print("must build custom fields!");
      setState(() {
        grimmItem.customFields!.forEach((key, value) {
          _customFields.add(
              CustomFieldWidget(customFieldKey: key, customFieldValue: value));
        });
      });
    }
  }
}

getIdForCategoryName(String dropdownValue) async {
  QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
      .collection("category")
      .where("name", isEqualTo: dropdownValue)
      .get();
  return snap.docs.first.id;
}
