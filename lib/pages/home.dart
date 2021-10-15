import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/widgets/button_home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _scanBarcode = 'Unknown';

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
                CustomHomeButton(title: "SCANNER", onPressed: scanQR,)
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

    setState(() {
      if (!barcodeScanRes.startsWith(Constants.QRCODE_STARTS_WITH)) {
        const snackBar =
            SnackBar(content: Text('QR code non géré par cette application.'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        _scanBarcode = barcodeScanRes;
      }
    });
  }
}
