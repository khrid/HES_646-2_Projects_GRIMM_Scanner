import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_item.dart';

class CreateObjectScreen extends StatefulWidget {
  static const routeName = '/create_object';

  const CreateObjectScreen({Key? key}) : super(key: key);

  @override
  _CreateObjectState createState() => _CreateObjectState();
}

class _CreateObjectState extends State<CreateObjectScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController descriptionController =
      TextEditingController(); // controlleur de la description
  TextEditingController typeController =
      TextEditingController(); // controlleur du type
  TextEditingController locationController =
      TextEditingController(); // controlleur du email
  TextEditingController availableController =
      TextEditingController(); // controlleur du available
  TextEditingController categorieController =
      TextEditingController(); // controlleur de la catégorie
  TextEditingController remarkController =
      TextEditingController(); // controlleur de la remarque

  @override
  Widget build(BuildContext context) {
    GrimmItem grimmItem = GrimmItem(
        id: "id",
        description: "description",
        location: "location",
        idCategory: "idCategory",
        available: true,
        remark: "remark");

    print("ItemDetail - GrimmItem - " + grimmItem.toString());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Création d'un nouvel objet"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
            // enlever le Center pour ne plus centrer verticalement
            child: SingleChildScrollView(
                child: Container(
                    child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
              ],
            ),
          ],
        )))));
  }
}
