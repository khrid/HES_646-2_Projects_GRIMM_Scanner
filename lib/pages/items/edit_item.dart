import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/pages/items/items_detail.dart';

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit_item';

  const EditItemScreen({Key? key}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItemScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController(
      text: "ObjectLouise"); // controlleur de la description
  TextEditingController locationController =
      TextEditingController(text: "C6"); // controlleur du email
  TextEditingController colorController =
      TextEditingController(text: "red"); // controlleur de la color
  TextEditingController categorieController = TextEditingController(
      text: "CkptVTldFGQLlF0QLRvv"); // controlleur de la catégorie
  TextEditingController remarkController = TextEditingController(
      text: "Pas de remarque"); // controlleur de la remarque
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
    //print("EditItemScreen - " + grimmItem.toString());

    descriptionController.text = grimmItem.description;
    locationController.text = grimmItem.location;
    colorController.text = grimmItem.color;
    categorieController.text = grimmItem.idCategory;
    remarkController.text = grimmItem.remark;

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
              "Modifiez l'objet",
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
                } else {
                  return null;
                }
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
                } else {
                  return null;
                }
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
            TextFormField(
              controller: colorController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Le champ 'Couleur' ne peut pas être vide";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: "Couleur",
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

                    for (var result in snapshot.data!.docs) {
                      categories.add(result['name']);
                      if (result.id == grimmItem.idCategory && firstLoad == 1) {
                        dropdownValue = result["name"];
                      }
                    }

                    firstLoad = 0;
                    return DropdownButtonFormField<String>(
                      value: dropdownValue,
                      hint: const Text("Category"),
                      iconSize: 24,
                      //elevation: 16,
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
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
                    grimmItem.description = descriptionController.text;
                    grimmItem.location = locationController.text;
                    grimmItem.color = colorController.text;
                    grimmItem.remark = remarkController.text;
                    grimmItem.idCategory =
                        await getIdForCategoryName(dropdownValue);
                    //print("End " + grimmItem.toString());
                    grimmItem.updateFirestore();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("VALIDER")),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

getIdForCategoryName(String dropdownValue) async {
  QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
      .collection("category")
      .where("name", isEqualTo: dropdownValue)
      .get();
  return snap.docs.first.id;
}
