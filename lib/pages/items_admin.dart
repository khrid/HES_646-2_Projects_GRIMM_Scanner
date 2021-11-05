import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';

import 'items_detail.dart';

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
                child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("items")
              .orderBy("description")
              .snapshots(),
          builder: buildItemsList,
        )))
        //drawer: const CustomDrawer(),
        );
  }

  Future<void> createItem() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Todo ! Et désactiver avant démo si pas fait")));
    setState(() {
      //Navigator.pushNamed(context, CreateAccountScreen.routeName);
    });
  }

  Widget buildItemsList(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Column(children: <Widget>[
        ListView(
          physics: const ClampingScrollPhysics(), // add t
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            GrimmItem grimmItem = GrimmItem.fromJson(doc);
            //print(grimmItem);
            Widget availability = (grimmItem.available)
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.clear,
                    color: Colors.red,
                  );
            return Card(
              child: ListTile(
                leading: availability,
                minLeadingWidth: 10,
                horizontalTitleGap: 10,
                title: Text(grimmItem.description),
                subtitle: Text(grimmItem.location),
                onTap: () {
                  Navigator.pushNamed(context, ItemDetail.routeName,
                      arguments:
                          Constants.grimmQrCodeStartsWith + grimmItem.id);
                },
              ),
            );
          }).toList(),
        )
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
