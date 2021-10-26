import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/utils/qrutils.dart';

class ItemDetail extends StatefulWidget {
  static const routeName = "/items/detail";

  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
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

    GrimmItem grimmItem = GrimmItem(
        id: qrcode.replaceAll(Constants.grimmQrCodeStartsWith, ""),
        description: "description",
        location: "location",
        idCategory: "idCategory",
        available: true,
        remark: "remark");

    print("ItemDetail - GrimmItem - " + grimmItem.toString());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Détail de l'objet"),
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
                QRUtils.generateQrWidgetFromString(grimmItem.getIdForQrCode()),
                const SizedBox(height: 20.0),
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('items')
                        .doc(grimmItem.id)
                        .snapshots(),
                    builder: buildItemDetails,
                  ),
                ),
                const SizedBox(height: 60.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                          fontFamily: "Raleway-Regular", fontSize: 14.0),
                      side: const BorderSide(width: 1.0, color: Colors.black),
                      padding: EdgeInsets.all(10.0),
                    ),
                    onPressed: () async {
                      // button for emprunter
                    },
                    child: Text("EMPRUNTER")),
                const SizedBox(height: 15.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                          fontFamily: "Raleway-Regular", fontSize: 14.0),
                      side: const BorderSide(width: 1.0, color: Colors.black),
                      padding: EdgeInsets.all(10.0),
                    ),
                    onPressed: () async {
                      // button for retourner
                    },
                    child: Text("RETOURNER")),
                const SizedBox(height: 20.0),
                /* pas nécessaire car on a la flèche pour naviguer (salut sylvain)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                          fontFamily: "Raleway-Regular", fontSize: 14.0),
                      side: const BorderSide(width: 1.0, color: Colors.black),
                      padding: EdgeInsets.all(10.0),
                    ),
                    onPressed: () async {
                      // button for autre scan
                      Navigator.pushNamed(context, "/");
                    },
                    child: Text("MENU")),*/
              ],
            ),
          ],
        )))));
  }
}

Widget buildItemDetails(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  // si on a des données
  if (snapshot.hasData) {
    // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
    // encore plus loin pour être sûr
    // si on a des données et que le doc existe
    if (snapshot.data!.data() != null) {
      var grimmItem = snapshot.data;
      print(grimmItem!.data());

      GrimmItem item = GrimmItem(
        id: grimmItem.id,
        description: grimmItem["description"],
        location: grimmItem["location"],
        idCategory: grimmItem["idCategory"],
        remark: grimmItem["remark"],
        available: grimmItem["available"],
      );

      var availability;
      if (item.available == true) {
        availability = "Disponible";
      } else {
        availability = "Emprunté";
      }

      return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text("Objet : " + item.description,
                style: TextStyle(color: Colors.black, fontSize: 14)),
            const SizedBox(height: 20.0),
            Text("Emplacement : " + item.location,
                style: TextStyle(color: Colors.black, fontSize: 14)),
            const SizedBox(height: 20.0),
            Text("Catégorie : " + item.idCategory,
                style: TextStyle(color: Colors.black, fontSize: 14)),
            const SizedBox(height: 20.0),
            Text("Statut : " + availability,
                style: TextStyle(color: Colors.black, fontSize: 14)),
            const SizedBox(height: 20.0),
          ]));
    } else {
      return Text("No item found");
    }
  } else {
    return Text("No item details yet :(");
  }
}
