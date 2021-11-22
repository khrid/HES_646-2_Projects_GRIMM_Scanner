import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/widgets/button_home.dart';

import 'categories_admin.dart';
import 'items_admin.dart';

class ItemsManageMenu extends StatefulWidget {
  static const routeName = "/items";

  const ItemsManageMenu({Key? key}) : super(key: key);

  @override
  _ItemsManageMenuState createState() => _ItemsManageMenuState();
}

class _ItemsManageMenuState extends State<ItemsManageMenu> {
  String _qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion de l'inventaire"),
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
                CustomHomeButton(
                    title: "Gérer les articles",
                    onPressed: navigateToItemsAdmin),
                const SizedBox(
                  height: 10.0,
                ),
                CustomHomeButton(
                    title: "Gérer les catégories",
                    onPressed: navigateToCategoriesAdmin)
              ],
            ),
          ],
        )))
        //drawer: const CustomDrawer(),
        );
  }

  Future<void> navigateToCategoriesAdmin() async {
    setState(() {
      Navigator.pushNamed(context, CategoriesAdmin.routeName);
    });
  }

  Future<void> navigateToItemsAdmin() async {
    setState(() {
      Navigator.pushNamed(context, ItemsAdmin.routeName);
    });
  }
}
