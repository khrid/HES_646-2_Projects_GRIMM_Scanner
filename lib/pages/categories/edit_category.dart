import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController categoryNameController = TextEditingController(
      text: "Catégorie"); // controlleur de la description

  int firstLoad = 1;
  List test = [];
  late GrimmCategory grimmCategory;

  @override
  Widget build(BuildContext context) {
    grimmCategory = (ModalRoute.of(context)!.settings.arguments == null
        ? null
        : ModalRoute.of(context)!.settings.arguments as GrimmCategory)!;

    if (grimmCategory is! GrimmCategory) {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, CategoriesAdmin.routeName, (Route<dynamic> route) => false));
    }
    //print("EditItemScreen - " + grimmCategory.toString());

    categoryNameController.text = grimmCategory.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edition"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(50),
          children: <Widget>[
            const Text(
              "Modifiez la catégorie",
              style: TextStyle(
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
                  return "Le champ 'Nom de la catégorie' ne peut pas être vide";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: "Nom de la catégorie",
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
                    //print("End " + grimmCategory.toString());
                    grimmCategory.updateFirestore();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Valider")),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
