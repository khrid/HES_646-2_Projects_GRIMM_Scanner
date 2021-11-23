import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/items/edit_item.dart';
import 'package:grimm_scanner/pages/items/items_admin.dart';
import 'package:grimm_scanner/pages/items/items_history.dart';
import 'package:grimm_scanner/utils/qrutils.dart';
import 'package:grimm_scanner/widgets/action_button.dart';
import 'package:grimm_scanner/widgets/expandable_fab.dart';
// printing libs
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';


class ItemDetail extends StatefulWidget {
  static const routeName = "/items/detail";

  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];
  late String qrcode;
  late GrimmItem grimmItem;

  late final CollectionReference _items =
      FirebaseFirestore.instance.collection("items");

  @override
  Widget build(BuildContext context) {
    qrcode = ModalRoute.of(context)!.settings.arguments == null
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
        color: "color",
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
        /*actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleAction,
              itemBuilder: (BuildContext context) {
                return Constants.actions.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],*/
      ),
      backgroundColor: Theme.of(context).primaryColor,
      // TODO https://flutter.dev/docs/cookbook/effects/expandable-fab
      floatingActionButton:
          /*FloatingActionButton(
          child: const Icon(
            Icons.access_time,
            color: Colors.white,
          ),
          onPressed: showHistory,
        )*/
          ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: showHistory,
            icon: const Icon(
              Icons.access_time,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => handleAction(Constants.actionPrintQr),
            icon: const Icon(
              Icons.print,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: editItem,
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => showAlertDialog(context),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          /*ActionButton(
              onPressed: () => _showAction(context, 2),
              icon: const Icon(Icons.videocam),
            ),*/
        ],
      ),
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
      /*floatingActionButton:
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
          )*/
    );
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
        var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suppression de l'objet"),
      content: Text("Êtes-vous vraiment sûr de vouloir supprimer cet objet ?"),
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

  void showHistory() {
    print("ItemDetail - showHistory - " + grimmItem.toString());
    Navigator.pushNamed(context, ItemHistory.routeName, arguments: grimmItem);
  }

  Widget buildItemDetails(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //on prend le user connecté pour enregistré le mouvement
    final user = Provider.of<GrimmUser?>(context);
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
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Couleur : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Text("" + item.color,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14)),
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
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14)),
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
                    textStyle: TextStyle(
                        fontFamily: "Raleway-Regular", fontSize: 14.0),
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    padding: EdgeInsets.all(10.0),
                  ),
                  onPressed: () async {
                    grimmItem.updateAvailability(user!.uid);
                  },
                  child: Text(item.available ? "EMPRUNTER" : "RETOURNER")),
              const SizedBox(height: 20.0),
            ]);
      } else {
        return Text("Pas d'objet trouvé, scannez à nouveau");
      }
    }
    return Text("Pas d'objet trouvé, scannez à nouveau");
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
      return const Text("");
    }
    return const Text("");
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleAction(String value) async {
    if (value == Constants.actionPrintQr) {
      print("ItemDetail - handleAction - print QR");
      final doc = pw.Document();
      doc.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => <pw.Widget>[
                pw.Center(
                  child: pw.Paragraph(
                    text: grimmItem.description,
                    style: const pw.TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.BarcodeWidget(
                      data: qrcode,
                      width: 150,
                      height: 150,
                      barcode: pw.Barcode.qrCode()),
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ]));

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save(),
          name: "qrgrimm_" + grimmItem.getDescriptionForPdfFilename() + "");
      //await Printing.sharePdf(bytes: await doc.save(), filename: "qrgrimm_"+grimmItem.getDescriptionForPdfFilename()+".pdf");

    }
  }
}
