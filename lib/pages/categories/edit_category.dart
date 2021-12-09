import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_category.dart';

import 'categories_admin.dart';

class CategoryUpdate extends StatefulWidget {
  static const routeName = "/items/categories/detail/update";

  const CategoryUpdate({Key? key}) : super(key: key);

  @override
  _CategoryUpdateState createState() => _CategoryUpdateState();
}

class _CategoryUpdateState extends State<CategoryUpdate> {
  final _key = GlobalKey<FormState>();

  int firstLoad = 1;
  List test = [];
  late GrimmCategory grimmCategory;

  @override
  Widget build(BuildContext context) {
    TextEditingController categoryNameController = TextEditingController(
        text: getTranslated(
            context, 'category')); // controlleur de la description

    grimmCategory = (ModalRoute.of(context)!.settings.arguments == null
        ? null
        : ModalRoute.of(context)!.settings.arguments as GrimmCategory)!;

    if (grimmCategory is! GrimmCategory) {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, CategoriesAdmin.routeName, (Route<dynamic> route) => false));
    }
    categoryNameController.text = grimmCategory.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_category_edit')!),
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
              getTranslated(context, 'category_modify')!,
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
              controller: categoryNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getTranslated(context, 'error_category_empty')!;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: getTranslated(context, 'category_name_simple')!,
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
                  .collection('cats')
                  .orderBy("name")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
                  // encore plus loin pour être sûr
                  // si on a des données et que le doc existe
                  if (snapshot.data != null) {
                    firstLoad = 0;
                  }
                }
                return const Text("");
              },
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
                    grimmCategory.name = categoryNameController.text;
                    grimmCategory.updateFirestore();
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
}
