import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/pages/items/items_filter.dart';

import 'create_item.dart';
import 'items_detail.dart';

class ItemsAdmin extends StatefulWidget {
  static const routeName = "/items/admin";

  const ItemsAdmin({Key? key}) : super(key: key);

  @override
  _ItemsAdminState createState() => _ItemsAdminState();
}

class _ItemsAdminState extends State<ItemsAdmin> {
  late String role;
  bool? filtersAvailable;
  List filtersCategory = [];
  late String search;
  late Stream<QuerySnapshot> searchStream;
  late Query searchQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search = "";
    searchQuery =
        FirebaseFirestore.instance.collection("items").orderBy("description");
    searchStream = searchQuery.snapshots();
  }

  refresh(bool? objectStatus, List categoryToDisplay) {
    print(" ---> state cat " + filtersCategory.toString());
    print(" ---> param cat " + categoryToDisplay.toString());
    print(" ---> search " + search);
    setState(() {
      searchQuery =
          FirebaseFirestore.instance.collection("items").orderBy("description");
      if (objectStatus != null) {
        filtersAvailable = objectStatus;
        searchQuery =
            searchQuery.where("available", isEqualTo: filtersAvailable);
        print(searchQuery.parameters);
      }

      if (categoryToDisplay.isNotEmpty) {
        filtersCategory = categoryToDisplay;
        print(" ---> state cat " + filtersCategory.toString());
        // limitation firebase, wherein que 10 elements à la fois

        searchQuery = searchQuery.where("idCategory", whereIn: filtersCategory);
        print(searchQuery.parameters);
      }

      if (search.isNotEmpty) {
        searchQuery = searchQuery
            .where('description', isGreaterThanOrEqualTo: search)
            .where('description', isLessThan: search + 'z');
        print(searchQuery.parameters);
      }
    });
    print(searchQuery.parameters);
    searchStream = searchQuery.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments is Map) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      role = arg['role'] ?? "";
      filtersAvailable = arg['available'] ?? "";
      print("----" + filtersAvailable.toString());
    } else {
      role = ModalRoute.of(context)!.settings.arguments == null
          ? "NULL"
          : ModalRoute.of(context)!.settings.arguments as String;
    }

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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: createItem,
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                  controller: TextEditingController(text: search),
                  decoration: const InputDecoration(
                      hintText: 'Rechercher...', border: InputBorder.none),
                  onChanged: null,
                  onSubmitted: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        search = value[0].toUpperCase() + value.substring(1);
                        refresh(filtersAvailable, filtersCategory);
                      }
                    });
                  },
                ),
                trailing:
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  IconButton(
                      onPressed: () {
                        print("empty");
                        setState(() {
                          search = "";
                          filtersAvailable = null;
                          filtersCategory = [];
                          refresh(filtersAvailable, filtersCategory);
                        });
                      },
                      icon: Icon(Icons.cancel)),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        print("filter");
                        Navigator.of(context).pushNamed(ItemsFilter.routeName,
                            arguments: {role, refresh});
                      },
                      icon: Icon(Icons.filter_list)),
                ]),
              ),
            ),
            Expanded(child: SingleChildScrollView(
                child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: searchStream,
                  builder: buildItemsList,
                )
              ],
            )))
          ],
        )

        //drawer: const CustomDrawer(),
        );
  }

  Future<void> createItem() async {
    setState(() {
      Navigator.pushNamed(context, CreateItemScreen.routeName);
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
                  //print("Role items_admin " + role);
                  var _qr = Constants.grimmQrCodeStartsWith + grimmItem.id;
                  Navigator.pushNamed(context, ItemDetail.routeName,
                      arguments: {'qrCode': _qr, 'role': role});
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
