import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/models/grimm_right.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/items/edit_item.dart';
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
  late String role;
  late GrimmItem grimmItem;
  late GrimmRight right;

  late final CollectionReference _items =
      FirebaseFirestore.instance.collection("items");
  late final CollectionReference _rights =
      FirebaseFirestore.instance.collection("rights");
  var isRight;

  @override
  void initState() {
    super.initState();
    isRightRole();
  }

  Future<bool> isRightRole() async {
    isRight = false;
    _rights.doc("objectButton").get().then((result) {
      right = GrimmRight.fromJson(result);

      if (right.permissions.contains(role)) {
        setState(() {
          isRight = true;
        });
      } else {
        setState(() {
          isRight = false;
        });
      }
    });
    return isRight;
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    qrcode = arg['qrCode'];
    role = arg['role'] ?? "null";

    //print("Role : " + role);
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

    double cWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_item_detail')!),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: (isRight == true)
          ? ExpandableFab(
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
              ],
            )
          : null,
      body: Center(
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
    );
  }

  Future<void> editItem() async {
    setState(() {
      grimmItem.populateItemInfoFromFirestore();
      Navigator.pushNamed(context, EditItemScreen.routeName,
              arguments: grimmItem)
          .then((value) => setState(() {}));
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(getTranslated(context, 'button_cancel')!),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(getTranslated(context, 'button_continue')!),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslated(context, 'snackbar_item_delete')!),
            duration: Duration(seconds: 2)));
        var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(getTranslated(context, 'alert_item_delete')!),
      content: Text(getTranslated(context, 'item_delete__are_you_sure')!),
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
    //print("ItemDetail - showHistory - " + grimmItem.toString());
    Navigator.pushNamed(context, ItemHistory.routeName, arguments: grimmItem);
  }

  Widget buildItemDetails(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //on prend le user connecté pour enregistré le mouvement
    final user = Provider.of<GrimmUser?>(context);
    // si on a des données
    if (snapshot.hasData) {
      // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
      // encore plus loin pour être sûr
      // si on a des données et que le doc existe
      if (snapshot.data!.data() != null) {
        GrimmItem item = GrimmItem.fromJson(snapshot.data);
        item.populateItemInfoFromFirestore();
        developer.log("ItemDetail - GrimmItem - " + grimmItem.toString(),
            name:
                "ch.grimmvs.scanner.lib.pages.items.ItemDetail.buildItemDetails");

        String availability;
        if (item.available == true) {
          availability = getTranslated(context, 'available')!;
        } else {
          availability = getTranslated(context, 'unavailable')!;
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
                  Text(getTranslated(context, 'item_location_detail')!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Flexible(
                      child: Text("" + item.location,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14))),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTranslated(context, 'item_color_detail')!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Text("" + item.color,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20.0),
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
                  Text(getTranslated(context, 'item_status_detail')!,
                      style: const TextStyle(
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
                  Text(getTranslated(context, 'item_remark_detail')!,
                      style: const TextStyle(
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
              buildCustomFields(),
              const SizedBox(height: 50.0),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc("borrowButton")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  //print(snapshot.data);
                  if (snapshot.hasData) {
                    if (snapshot.data!.data() != null) {
                      right = GrimmRight.fromJson(snapshot.data);
                      if (right.permissions.contains(role)) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    textStyle: const TextStyle(
                                        fontFamily: "Raleway-Regular",
                                        fontSize: 14.0),
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.black),
                                    padding: const EdgeInsets.all(10.0),
                                  ),
                                  onPressed: () async {
                                    grimmItem.updateAvailability(user!.uid);
                                  },
                                  child: Text(item.available
                                      ? getTranslated(context, 'button_borrow')!
                                      : getTranslated(
                                          context, 'button_give_back')!)),
                              const SizedBox(height: 20.0),
                            ]);
                      }
                    } else {
                      return Text(getTranslated(context, 'error_simple')!);
                    }
                  }
                  return const SizedBox(
                    height: 0,
                  );
                },
              ),
            ]);
      } else {
        return Text(getTranslated(context, 'error_item_not_found')!);
      }
    }
    return Text(getTranslated(context, 'error_item_not_found')!);
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
            Text(getTranslated(context, 'item_category_detail')!,
                style: const TextStyle(
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
              child: Text(getTranslated(context, 'button_close')!),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleAction(String value) async {
    if (value == Constants.actionPrintQr) {
      //print("ItemDetail - handleAction - print QR");
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
    }
  }

  buildCustomFields() {
    var list = <Widget>[];
    if (grimmItem.customFields!.isNotEmpty) {
      grimmItem.customFields!.forEach((key, value) {
        list.add(const SizedBox(height: 20.0));
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Text(key.toString() + " : ",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))),
            Flexible(
                child: Text("" + value,
                    style: const TextStyle(color: Colors.black, fontSize: 14))),
          ],
        ));
      });
      return Container(
        child: Column(
          children: list,
        ),
      );
    }
    return Container();
  }
}
