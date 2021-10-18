import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/pages/items_detail.dart';
import 'package:grimm_scanner/widgets/button_home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomHomeButton(title: "SCANNER", onPressed: scanQR)
              ],
            ),
          ],
        ))
        //drawer: const CustomDrawer(),
        );
  }

  Future<void> scanQR() async {
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
      if (barcodeScanRes.startsWith(Constants.QRCODE_STARTS_WITH)) {
        // on le stocke dans la variable du state
        _qrCode = barcodeScanRes;
        // on passe à l'écran de détail d'un objet, en transmettant le qr plus loin
        Navigator.pushNamed(context, ItemDetail.routeName, arguments: _qrCode);

        // Sinon s'il est égal à -1 (quand l'utilisateur appuie sur "annuler"
        // depuis l'écran de scannage
      } else if (barcodeScanRes == "-1") {
        // on affiche un message indiquant que l'action a été annulée
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: const Text("Lecture QR annulée.")));

        // sinon
      } else {
        // on affiche un message indiquant qu'on ne gère pas ce code QR
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("QR code scanné non géré par cette application.")));
      }
    });
  }
}
