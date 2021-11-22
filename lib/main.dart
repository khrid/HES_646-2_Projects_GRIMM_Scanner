import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/pages/accounts_admin.dart';
import 'package:grimm_scanner/pages/accounts_user_detail.dart';
import 'package:grimm_scanner/pages/categories_admin.dart';
import 'package:grimm_scanner/pages/categories_detail.dart';
import 'package:grimm_scanner/pages/create_account.dart';
import 'package:grimm_scanner/pages/edit_category.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/pages/items_history.dart';
import 'package:grimm_scanner/pages/items_admin.dart';
import 'package:grimm_scanner/pages/items_detail.dart';
import 'package:grimm_scanner/pages/login_group.dart';
import 'package:grimm_scanner/pages/items_manage_menu.dart';
import 'package:grimm_scanner/pages/update_account.dart';
import 'dart:async';

import 'models/grimm_user.dart';
import 'pages/create_item.dart';
import 'pages/edit_item.dart';
import 'pages/login.dart';
import 'service/authentication_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  /*static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);*/

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
        print("Flutterfire initialized successfully");
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void getTestFirebaseValue() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("tests")
        .doc("OqwvFM4JOPZAUWCeiDhv")
        .get();
    print("Value retrieved from Firebase Firestore : " + ds.get("target"));
  }

  @override
  void initState() {
    initializeFlutterFire();
    getTestFirebaseValue();
    super.initState();
  }

  Widget build(BuildContext context) {
    /*analytics.logEvent(
        name: "test_event", parameters: <String, dynamic>{'sender': 'david'});*/
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    // TODO: implement build

    return StreamProvider<GrimmUser?>.value(
        initialData: null,
        value: AuthenticationService().user,
        lazy: false,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GRIMM Scanner',
            theme: ThemeData(
              primarySwatch: Colors.grey,
              primaryColor: const Color(0xFFECF0F9),
            ),
            //navigatorObservers: <NavigatorObserver>[observer],
            home: Login(),
            initialRoute: '/',
            routes: {
              LoginGroup.routeName: (context) => const LoginGroup(),
              Home.routeName: (context) => const Home(),
              ItemDetail.routeName: (context) => const ItemDetail(),
              ItemHistory.routeName: (context) => const ItemHistory(),
              ItemsManageMenu.routeName: (context) => const ItemsManageMenu(),
              ItemsAdmin.routeName: (context) => const ItemsAdmin(),
              CategoriesAdmin.routeName: (context) => const CategoriesAdmin(),
              CategoryDetail.routeName: (context) => const CategoryDetail(),
              CategoryUpdate.routeName: (context) => const CategoryUpdate(),
              AccountsAdmin.routeName: (context) => const AccountsAdmin(),
              UserDetail.routeName: (context) => const UserDetail(),
              UserUpdate.routeName: (context) => const UserUpdate(),
              CreateAccountScreen.routeName: (context) =>
                  const CreateAccountScreen(),
              CreateItemScreen.routeName: (context) => const CreateItemScreen(),
              EditItemScreen.routeName: (context) => const EditItemScreen(),
            }));
  }
}
