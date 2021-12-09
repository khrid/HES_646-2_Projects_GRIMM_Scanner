import 'dart:async';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_right.dart';
import 'package:grimm_scanner/pages/account/accounts_admin.dart';
import 'package:grimm_scanner/pages/items/items_detail.dart';
import 'package:grimm_scanner/pages/profile/profile.dart';
import 'package:grimm_scanner/pages/rights/admin_rights.dart';
import 'package:grimm_scanner/widgets/button_home.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account/accounts_admin.dart';
import 'items/items_admin.dart';
import 'items/items_manage_menu.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _qrCode = 'Unknown';
  //late final GrimmUser user;
  late GrimmRight right;
  late SharedPreferences prefs;
  String _connectionStatus = 'Unknown';
  bool connectionLost = false;
  bool _connectionLost = false;
  late ConnectivityResult previousState;
  late final bool _firstLaunch;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late String role;

  Future<bool> isFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("first_time", true); // activer pour reset le first_time
    bool isFirstTime = prefs.getBool('first_time') ?? false;
    if (isFirstTime) {
      //print('premier lancement, on switch la variable');
      setState(() {
        _firstLaunch = true;
      });
      prefs.setBool('first_time', false);
      // si on a internet lors du premier lancement
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (!await InternetConnectionChecker().hasConnection) {
        //print('First launch but no Internet, sync needed later');
        prefs.setBool("sync_needed", true);
      } else {
        forceLocalSync();
      }
      return false;
    }
    return false;
  }

  void forceLocalSync() {
    //print('Force sync Firebase');
    FirebaseFirestore.instance.collection("items").snapshots().toList();
    FirebaseFirestore.instance.collection("items").get();
    FirebaseFirestore.instance.collection("category").snapshots().toList();
    FirebaseFirestore.instance.collection("category").get();
    FirebaseFirestore.instance.collection("history").snapshots().toList();
    FirebaseFirestore.instance.collection("history").get();
    FirebaseFirestore.instance.collection("users").snapshots().toList();
    FirebaseFirestore.instance.collection("users").get();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    isFirstTime();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void setPersistenceEnabled() async {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
    /*print("isPersistenceEnabled : " +
        FirebaseFirestore.instance.settings.persistenceEnabled.toString());*/
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    role = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as String;
    if (role == "NULL") {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false));
    }
    //print("Permissions : " + role);
    //print("testHomepage");
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'appbar_menu')!),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: goToProfile,
          child: Icon(
            Icons.manage_accounts,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/logo_grimm_black.jpg"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.05), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //Gestion des accès : StreamBuilder pour le button scan
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc("scanButton")
                    .snapshots(),
                builder: buildButtonScan,
              ),
              //Gestion des accès : StreamBuilder pour le button d'accès de la gestion des utilisateurs
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc("userButton")
                    .snapshots(),
                builder: buildButtonAdmin,
              ),
              //Gestion des accès : StreamBuilder pour le button d'accès de la gestion d'inventaire
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc("inventoryButton")
                    .snapshots(),
                builder: buildButtonInventory,
              ),

              //Gestion des accès : StreamBuilder pour le button d'accès au droits
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc("rightsButton")
                    .snapshots(),
                builder: buildButtonRights,
              ),
              //Gestion des accès : StreamBuilder pour le button d'accès au droits
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc("listItems")
                    .snapshots(),
                builder: buildButtonItemList,
              ),
            ],
          ),
        ));
  }

  Widget buildButtonItemList(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //print(snapshot.data);
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);

        if (right.permissions.contains(role)) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CustomHomeButton(
                title: getTranslated(context, 'button_item_list')!,
                onPressed: navigateToListItem),
            const SizedBox(
              height: 10,
            ),
          ]);
        }
      } else {
        return Text(getTranslated(context, 'error_simple')!);
      }
    }
    return const SizedBox(
      height: 0,
    );
  }

  Widget buildButtonAdmin(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //print(snapshot.data);
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);

        if (right.permissions.contains(role)) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CustomHomeButton(
                title: getTranslated(context, 'button_users_admin')!,
                onPressed: navigateToUsersAdmin),
            const SizedBox(
              height: 10,
            ),
          ]);
        }
      } else {
        return Text(getTranslated(context, 'error_simple')!);
      }
    }
    return const SizedBox(
      height: 0,
    );
  }

  Widget buildButtonInventory(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //print(snapshot.data);
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);

        if (right.permissions.contains(role)) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CustomHomeButton(
                title: getTranslated(context, 'button_objects')!,
                onPressed: navigateToItemsCatAdmin),
            const SizedBox(
              height: 10.0,
            ),
          ]);
        }
      } else {
        return Text(getTranslated(context, 'error_simple')!);
      }
    }
    return const SizedBox(
      height: 0,
    );
  }

  Widget buildButtonRights(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //print(snapshot.data);
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);
        if (right.permissions.contains(role)) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CustomHomeButton(
                title: getTranslated(context, 'button_rights')!,
                onPressed: navigateToAdminRights),
            const SizedBox(
              height: 10,
            ),
          ]);
        }
      } else {
        return Text(getTranslated(context, 'error_simple')!);
      }
    }
    return const SizedBox(
      height: 0,
    );
  }

  Widget buildButtonScan(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //print(snapshot.data);
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);

        if (right.permissions.contains(role)) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CustomHomeButton(
                title: getTranslated(context, 'button_scan')!,
                onPressed: scanQR),
            const SizedBox(
              height: 10,
            ),
          ]);
        }
      } else {
        return Text(getTranslated(context, 'error_simple')!);
      }
    }
    return const SizedBox(
      height: 0,
    );
  }

  Future<void> navigateToUsersAdmin() async {
    setState(() {
      Navigator.pushNamed(context, AccountsAdmin.routeName, arguments: role);
    });
  }
  
  Future<void> navigateToListItem() async {
    setState(() {
      Navigator.pushNamed(context, ItemsAdmin.routeName, arguments: role);
    });
  }

  Future<void> navigateToAdminRights() async {
    setState(() {
      Navigator.pushNamed(context, RightsAdmin.routeName, arguments: role);
    });
  }

  Future<void> navigateToItemsCatAdmin() async {
    setState(() {
      Navigator.pushNamed(context, ItemsManageMenu.routeName, arguments: role);
    });
  }

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
      // print("scanQR called");
      String barcodeScanRes;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.QR);
        //print(barcodeScanRes);
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
              arguments: {'qrCode': _qrCode, 'role': role});

          // Sinon s'il est égal à -1 (quand l'utilisateur appuie sur "annuler"
          // depuis l'écran de scannage
        } else if (barcodeScanRes == "-1") {
          // on affiche un message indiquant que l'action a été annulée
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(getTranslated(context, 'snackbar_error_qr_cancel')!)));

          // sinon
        } else {
          // on affiche un message indiquant qu'on ne gère pas ce code QR
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(getTranslated(context, 'snackbar_wrong_qr')!)));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(getTranslated(context, 'snackbar_cant_computer_scan')!)));
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    // si on a du réseau (mais pas forcément internet...)
    //print("connection lost : " + connectionLost.toString());
    //print("connectivity result : " + result.toString());
    bool syncNeeded = prefs.getBool("sync_needed") ?? false;
    if (result != ConnectivityResult.none) {
      // check si on a internet
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      //print("has internet : " + hasInternet.toString());
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (hasInternet && _connectionLost) {
        if (syncNeeded) {
          forceLocalSync();
          prefs.setBool("sync_needed", false);
        }
        setState(() {
          _connectionLost = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated(context, 'snackbar_connection_ok')!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: const Color(0xFF1CB731),
        ));
      }
    } else {
      setState(() {
        _connectionLost = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          getTranslated(context, 'snackbar_no_connection')!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(days: 365),
        backgroundColor: const Color(0xFFB71C1C),
      ));
      //}
    }
  }

  goToProfile() async {
    Navigator.pushNamed(context, ProfileAdmin.routeName, arguments: role);
  }
}
