import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/accounts_admin.dart';
import 'package:grimm_scanner/pages/items_detail.dart';
import 'package:grimm_scanner/widgets/button_home.dart';
import 'package:provider/provider.dart';

import 'accounts_admin.dart';
import 'create_account.dart';
import 'create_item.dart';
import 'items_admin.dart';
import 'items_admin.dart';

class Home extends StatefulWidget {
    static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _qrCode = 'Unknown';
  //late final GrimmUser user;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GrimmUser?>(context);
    print(user);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
            child: SingleChildScrollView(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomHomeButton(title: "SCANNER", onPressed: scanQR),
                    const SizedBox(
                      height: 10.0,
                    ),
                    /*CustomHomeButton(title: "FAKE SCAN", onPressed: fakeScan),
                const SizedBox(height: 10.0,),*/
                    /*CustomHomeButton(title: "FAKE SCAN", onPressed: fakeScan),
                    const SizedBox(
                      height: 10.0,
                    ),*/
                    CustomHomeButton(
                        title: "Gérer les utilisateurs",
                        onPressed: navigateToUsersAdmin),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomHomeButton(
                        title: "Gérer l'inventaire",
                        onPressed: navigateToItemsAdmin)
                  ],
                ),
              ],
            )))
        //drawer: const CustomDrawer(),
        );
  }

  Future<void> navigateToUsersAdmin() async {
    setState(() {
      Navigator.pushNamed(context, AccountsAdmin.routeName);
    });
  }

  Future<void> navigateToItemsAdmin() async {
    setState(() {
      Navigator.pushNamed(context, ItemsAdmin.routeName);
    });
  }

  /*Future<void> createItem() async {
    setState(() {
      Navigator.pushNamed(context, CreateItemScreen.routeName);
    });
  }*/

  Future<void> fakeScan() async {
    setState(() {
      _qrCode = Constants.grimmQrCodeStartsWith + "1VEx5uRRtuUVk8Bf7597";
      // on passe à l'écran de détail d'un objet, en transmettant le qr plus loin
      Navigator.pushNamed(context, ItemDetail.routeName, arguments: _qrCode);
    });
  }

  Future<void> scanQR() async {
    // La librairie QR n'est pas prévue pour le web, il faut informer au cas où
    if (!kIsWeb) {
      print("scanQR called");
      String barcodeScanRes;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.QR);
        print(barcodeScanRes);
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      // Quand on reconnait un code QR
      setState(() {
        // S'il commence bien par la chaine "QRGRIMM_" (pour être sûr de ne
        // travailler uniquement avec un QR de notre application
        if (barcodeScanRes.startsWith(Constants.grimmQrCodeStartsWith)) {
          // on le stocke dans la variable du state
          _qrCode = barcodeScanRes;
          // on passe à l'écran de détail d'un objet, en transmettant le qr plus loin
          Navigator.pushNamed(context, ItemDetail.routeName,
              arguments: _qrCode);

          // Sinon s'il est égal à -1 (quand l'utilisateur appuie sur "annuler"
          // depuis l'écran de scannage
        } else if (barcodeScanRes == "-1") {
          // on affiche un message indiquant que l'action a été annulée
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lecture QR annulée.")));

          // sinon
        } else {
          // on affiche un message indiquant qu'on ne gère pas ce code QR
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("QR code scanné non géré par cette application.")));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "La lecture QR n'est possible que depuis l'application native Android / iOS.")));
    }
  }
}
