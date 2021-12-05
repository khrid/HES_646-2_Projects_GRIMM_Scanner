import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grimm_scanner/pages/account/accounts_admin.dart';
import 'package:grimm_scanner/pages/account/accounts_user_detail.dart';
import 'package:grimm_scanner/pages/categories/categories_admin.dart';
import 'package:grimm_scanner/pages/categories/categories_detail.dart';
import 'package:grimm_scanner/pages/account/create_account.dart';
import 'package:grimm_scanner/pages/categories/edit_category.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/pages/items/items_history.dart';
import 'package:grimm_scanner/pages/items/items_admin.dart';
import 'package:grimm_scanner/pages/items/items_detail.dart';
import 'package:grimm_scanner/pages/login/login_group.dart';
import 'package:grimm_scanner/pages/items/items_manage_menu.dart';
import 'package:grimm_scanner/pages/account/update_account.dart';
import 'package:grimm_scanner/pages/profile/profile.dart';
import 'package:grimm_scanner/pages/rights/admin_rights.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_localization.dart';
import 'models/grimm_user.dart';
import 'pages/items/create_item.dart';
import 'pages/items/edit_item.dart';
import 'pages/login/login.dart';
import 'pages/rights/admin_rights_detail.dart';
import 'service/authentication_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
    static void setLocale(BuildContext context, Locale locale) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    state!.setLocale(locale);
  }
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  var subscription;
  var connectionStatus;

  
  
  Locale? _locale;
  void setLocale(Locale locale) {
        setState(() {
          _locale = locale;}); }


  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
        //print("Flutterfire initialized successfully");
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
    //print("Value retrieved from Firebase Firestore : " + ds.get("target"));
  }

  @override
  void initState() {
    initializeFlutterFire();
    getTestFirebaseValue();
    super.initState();
  }



  Widget build(BuildContext context) {
    // gestion de l'orientation de l'écran
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<GrimmUser?>.value(
        initialData: null,
        value: AuthenticationService().user,
        lazy: false,
        child: MaterialApp(
           localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,],
            //supported languages
            locale: _locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('fr', 'FR'),
              Locale('de', 'DE'),],
              //to check if the local codes are the same to the device codes
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (var locale in supportedLocales) {
                      if (locale.languageCode == deviceLocale!.languageCode &&
                          locale.countryCode == deviceLocale.countryCode) {
                        return deviceLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
            debugShowCheckedModeBanner: false,
            title: 'GRIMM Scanner',
            theme: ThemeData(
              primarySwatch: Colors.grey,
              primaryColor: const Color(0xFFECF0F9),
            ),
            home: Login(),
            initialRoute: '/',
            routes: {
              LoginGroup.routeName: (context) => const LoginGroup(),
              ProfileAdmin.routeName: (context) => const ProfileAdmin(),
              RightsAdmin.routeName: (context) => const RightsAdmin(),
              RightsAdminDetail.routeName: (context) =>
                  const RightsAdminDetail(),
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
            },
            
              ));
  }
}