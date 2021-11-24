import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/widgets/button_home.dart';
import 'package:grimm_scanner/pages/categories/categories_admin.dart';
import 'items_admin.dart';

class ItemsManageMenu extends StatefulWidget {
  static const routeName = "/items";

  const ItemsManageMenu({Key? key}) : super(key: key);

  @override
  _ItemsManageMenuState createState() => _ItemsManageMenuState();
}

class _ItemsManageMenuState extends State<ItemsManageMenu> {
  String _qrCode = 'Unknown';
  late String role;

  @override
  Widget build(BuildContext context) {
    role = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as String;
    if (role == "NULL") {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion de l'inventaire"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: 
      Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo_grimm_black.jpg"),
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.05), BlendMode.dstATop),
                        fit: BoxFit.cover,
                        ),),   
        child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                CustomHomeButton(
                    title: "Gérer les articles",
                    onPressed: navigateToItemsAdmin),
                const SizedBox(
                  height: 10.0,
                ),
                CustomHomeButton(
                    title: "Gérer les catégories",
                    onPressed: navigateToCategoriesAdmin)
              ],)]
            ),
          
        )
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
      print("Role items_manage_menu" + role);
      Navigator.pushNamed(context, ItemsAdmin.routeName, arguments: role);
    });
  }
}
