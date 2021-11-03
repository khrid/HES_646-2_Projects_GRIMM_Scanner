import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/widgets/button_home.dart';

import 'create_account.dart';

class ItemsAdmin extends StatefulWidget {
  static const routeName = "/items/admin";
  const ItemsAdmin({Key? key}) : super(key: key);

  @override
  _ItemsAdminState createState() => _ItemsAdminState();
}

class _ItemsAdminState extends State<ItemsAdmin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion de l'inventaire"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: createItem,
          child: const Icon(Icons.add),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[],
                    ),
                  ],
                )))
      //drawer: const CustomDrawer(),
    );
  }

  Future<void> createItem() async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todo ! Et désactiver avant démo si pas fait")));
    setState(() {
      //Navigator.pushNamed(context, CreateAccountScreen.routeName);
    });
  }
}
