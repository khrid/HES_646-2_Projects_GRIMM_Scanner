import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'create_account.dart';

class AccountsAdmin extends StatefulWidget {
  static const routeName = "/accounts/admin";

  const AccountsAdmin({Key? key}) : super(key: key);

  @override
  _AccountsAdminState createState() => _AccountsAdminState();
}

class _AccountsAdminState extends State<AccountsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion des utilisateurs"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: createUser,
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

  Future<void> createUser() async {
    setState(() {
      Navigator.pushNamed(context, CreateAccountScreen.routeName);
    });
  }
}
