import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
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
          title: Text(getTranslated(context, 'appbar_item_list')!),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomHomeButton(
                        title: getTranslated(context, 'button_items_admin')!,
                        onPressed: navigateToItemsAdmin),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomHomeButton(
                        title:
                            getTranslated(context, 'button_categories_admin')!,
                        onPressed: navigateToCategoriesAdmin)
                  ],
                )
              ]),
        ));
  }

  Future<void> navigateToCategoriesAdmin() async {
    setState(() {
      Navigator.pushNamed(context, CategoriesAdmin.routeName);
    });
  }

  Future<void> navigateToItemsAdmin() async {
    setState(() {
      Navigator.pushNamed(context, ItemsAdmin.routeName, arguments: role);
    });
  }
}
