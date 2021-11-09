import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_item.dart';

import 'edit_item.dart';

class CreateItemScreen extends StatefulWidget {
  static const routeName = '/create_item';

  const CreateItemScreen({Key? key}) : super(key: key);

  @override
  _CreateItemState createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItemScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController(
      text: "ObjectLouise"); // controlleur de la description
  TextEditingController locationController =
      TextEditingController(text: "C6"); // controlleur du email
  TextEditingController categorieController =
      TextEditingController(); // controlleur de la catégorie
  TextEditingController remarkController = TextEditingController(
      text: "Pas de remarque"); // controlleur de la remarque

  String dropdownValue = "pansement";

  @override
  Widget build(BuildContext context) {
    GrimmItem grimmItem = GrimmItem(
        //id: "id",
        description: "description",
        location: "location",
        idCategory: "idCategory",
        available: true,
        remark: "remark");

    print("ItemDetail - GrimmItem - " + grimmItem.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Création"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(50),
          children: <Widget>[
            const Text(
              "Créez un nouvel objet",
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
              controller: descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Le champ 'Nom de l'objet' ne peut pas être vide";
                } else
                  return null;
              },
              decoration: const InputDecoration(
                labelText: "Nom de l'objet",
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
            TextFormField(
              controller: locationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Le champ 'Emplacement' ne peut pas être vide";
                } else
                  return null;
              },
              decoration: const InputDecoration(
                labelText: 'Emplacement',
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
                      hint: Text("Category"),
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
                        labelStyle: TextStyle(color: Colors.black),
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
                          this.dropdownValue = value!;
                        });
                      },
                    );
                  }
                }
                return const Text("");
              },
            ),
            /*TextFormField(
              controller: categorieController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le champ "Catégorie" ne peut pas être vide';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Catégorie',
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
              cursorColor: Colors.black,
            ),*/
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: remarkController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le champ "Remarque" ne peut pas être vide';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Remarque',
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
              cursorColor: Colors.black,
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
                    print(dropdownValue);
                    if (_key.currentState!.validate()) {
                      GrimmItem item = GrimmItem(
                          description: descriptionController.text,
                          location: locationController.text,
                          remark: remarkController.text,
                          idCategory: await getIdForCategoryName(dropdownValue),
                          available: true);
                      await item.saveToFirestore();
                      print("Item CREATE" + item.toString());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Objet créé avec succès")));
                      Navigator.pushNamed(context, "/");
                    }
                  }
                },
                child: Text("VALIDER")),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
