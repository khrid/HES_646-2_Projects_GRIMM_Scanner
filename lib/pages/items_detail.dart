import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/utils/qrutils.dart';
import 'package:grimm_scanner/pages/home.dart';

class ItemDetail extends StatefulWidget {
  static const routeName = "/items/detail";

  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    final qrcode = ModalRoute.of(context)!.settings.arguments as String;

    final grimmItem = ModalRoute.of(context)!.settings.arguments as GrimmItem;
    print("Item Object " + grimmItem.toString());

    // TODO récupérer les infos de Firebase avec le contenu de "qrcode"

    return Scaffold(
        appBar: AppBar(
          title: const Text("Détail de l'objet"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
            // enlever le Center pour ne plus centrer verticalement
            child: SingleChildScrollView(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                QRUtils.generateQrWidgetFromString(qrcode),
                const SizedBox(height: 20.0),
                Text(qrcode),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('items')
                        .doc(grimmItem.id)
                        .snapshots(),
                    builder: buildItemDetails,
                  ),
                ),
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
                const SizedBox(height: 20.0),
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
                    child: Text("MENU")),
              ],
            ),
          ],
        ))));
  }
}

Widget buildItemDetails(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  if (snapshot.hasData) {
    var grimmItem = snapshot.data;
    GrimmItem item = GrimmItem(
      description: grimmItem!["description"],
      location: grimmItem["location"],
      idCategory: grimmItem["idCategory"],
      remark: grimmItem["remark"],
      available: grimmItem["available"],
    );
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Emplacement: " + item.location,
          style: TextStyle(color: Colors.black, fontSize: 14)),
      const SizedBox(height: 20.0),
      Text("Catégorie: ", style: TextStyle(color: Colors.black, fontSize: 14)),
      const SizedBox(height: 20.0),
      Text("Date d'emprunt: ",
          style: TextStyle(color: Colors.black, fontSize: 14)),
      const SizedBox(height: 20.0),
      Text("Status: ", style: TextStyle(color: Colors.black, fontSize: 14)),
      const SizedBox(height: 20.0),
    ]));
  } else {
    return Text("No item details yet :(");
  }
}
