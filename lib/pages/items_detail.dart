import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/pages/items_admin.dart';
import 'package:grimm_scanner/utils/qrutils.dart';

import 'edit_item.dart';

class ItemDetail extends StatefulWidget {
  static const routeName = "/items/detail";

  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  late GrimmItem grimmItem;

  late CollectionReference _items =
      FirebaseFirestore.instance.collection("items");

  @override
  Widget build(BuildContext context) {
    final qrcode = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as String;

    // on s'assure que "qrcode" vaut quelque chose, car sinon plus loin ça va péter
    // s'il vaut "NULL", on force le retour au home screen
    if (qrcode == "NULL") {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false));
    }

    grimmItem = GrimmItem(
        id: qrcode.replaceAll(Constants.grimmQrCodeStartsWith, ""),
        description: "description",
        location: "location",
        idCategory: "idCategory",
        available: true,
        remark: "remark");
    grimmItem.populateItemInfoFromFirestore();

    print("ItemDetail - GrimmItem - " + grimmItem.toString());

    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Détail de l'objet"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        /*floatingActionButton: FloatingActionButton(
          onPressed: editItem,
          child: const Icon(Icons.edit),
        ),*/
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
                QRUtils.generateQrWidgetFromString(grimmItem.getIdForQrCode()),
                const SizedBox(height: 20.0),
                Container(
                  width: cWidth,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('items')
                        .doc(grimmItem.id)
                        .snapshots(),
                    builder: buildItemDetails,
                  ),
                ),
                const SizedBox(height: 60.0),
              ],
            ),
          ],
        )))),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              editItem();
            },
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => showAlertDialog(context),
            heroTag: null,
          )
        ]));
  }

  Future<void> editItem() async {
    setState(() {
      grimmItem.populateItemInfoFromFirestore();
      Navigator.pushNamed(context, EditItemScreen.routeName,
          arguments: grimmItem);
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continuer"),
      onPressed: () {
        _items.doc(grimmItem.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Objet supprimé'),
            duration: Duration(seconds: 2)));
        Navigator.pushNamedAndRemoveUntil(
            context, ItemsAdmin.routeName, (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suppression de l'objet"),
      content: Text("Etes vous vraiment sûr de vouloir supprimer cet objet?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Widget buildItemDetails(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  /*late CollectionReference _items;

  _items = FirebaseFirestore.instance.collection("items");

  Future<void> updateItem(GrimmItem i) async {
    _items.doc(i.id).update(i.toJson());
  }*/

  // si on a des données
  if (snapshot.hasData) {
    // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
    // encore plus loin pour être sûr
    // si on a des données et que le doc existe
    if (snapshot.data!.data() != null) {
      GrimmItem item = GrimmItem.fromJson(snapshot.data);

      String availability;
      if (item.available == true) {
        availability = "Disponible";
      } else {
        availability = "Emprunté";
      }

      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("" + item.description,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Emplacement : ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text("" + item.location,
                    style: const TextStyle(color: Colors.black, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20.0),
            /*Text("Catégorie : " + item.idCategory,
            style: TextStyle(color: Colors.black, fontSize: 14)),*/
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('category')
                  .doc(item.idCategory)
                  .snapshots(),
              builder: buildItemCategory,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Statut : ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text("" + availability,
                    style: const TextStyle(color: Colors.black, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Remarque : ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Flexible(
                  child: Text("" + item.remark,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14)),
                )
              ],
            ),
            const SizedBox(height: 50.0),
            //if (item.available)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle:
                      TextStyle(fontFamily: "Raleway-Regular", fontSize: 14.0),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  padding: EdgeInsets.all(10.0),
                ),
                onPressed: () async {
                  //if (item.available) {
                  item.available = !item.available;
                  //updateItem(item);
                  item.saveToFirestore();
                  //} else {
                  //  //TODO: définir l'action
                  //}
                },
                child: Text(item.available ? "EMPRUNTER" : "RETOURNER")),
            //const SizedBox(height: 15.0),
            /*if (!item.available)
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                    fontFamily: "Raleway-Regular", fontSize: 14.0),
                side: const BorderSide(width: 1.0, color: Colors.black),
                padding: EdgeInsets.all(10.0),
              ),
              onPressed: () async {
                if (!item.available) {
                  item.available = true;
                  //updateItem(item);
                  item.saveToFirestore();
                } else {
                  //TODO: définir l'action
                }
              },
              child: Text("RETOURNER")),*/
            const SizedBox(height: 20.0),
          ]);
    } else {
      return Text("Pas d'object trouvé, scannez à nouveau");
    }
  } else {
    return Text("No item details yet :(");
  }
}

Widget buildItemCategory(BuildContext context,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  // si on a des données
  if (snapshot.hasData) {
    // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
    // encore plus loin pour être sûr
    // si on a des données et que le doc existe
    if (snapshot.data!.data() != null) {
      var grimmCategory = snapshot.data;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Catégorie : ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Text("" + grimmCategory!.data()!["name"],
              style: const TextStyle(color: Colors.black, fontSize: 14)),
        ],
      );
    }
  }
  return const Text("");
}
