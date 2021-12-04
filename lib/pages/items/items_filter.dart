import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_category.dart';
import 'package:grimm_scanner/pages/items/items_admin.dart';

class ItemsFilter extends StatefulWidget {
  static const routeName = "/items/filters";

  const ItemsFilter({Key? key}) : super(key: key);

  @override
  _ItemsFilterState createState() => _ItemsFilterState();
}

class _ItemsFilterState extends State<ItemsFilter> {
  late bool available = true;
  late bool borrowed = true;
  late var categoryStatus = {};
  bool firstbuild = true;
  late String role;
  late Function refresh;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //print(ModalRoute.of(context)!.settings.);
    //role = ModalRoute.of(context)!.settings.arguments ?? "";
    //refresh = arg['refresh'] ?? "";

    final arguments = ModalRoute.of(context)!.settings.arguments as LinkedHashSet;
    role = arguments.first; // very ugly but it works for now
    refresh = arguments.last;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Filtrer"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          const Text("Disponiblité",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterChip(
                selected: available,
                label: const Text('Disponible'),
                onSelected: (bool value) {
                  setState(() {
                    available = !available;
                  });
                },
              ),
              SizedBox(
                width: 20,
              ),
              FilterChip(
                selected: borrowed,
                label: const Text('Emprunté'),
                onSelected: (bool value) {
                  setState(() {
                    borrowed = !borrowed;
                  });
                },
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Catégorie",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              StreamBuilder<QuerySnapshot>(
                builder: buildCategoryChips,
                stream: FirebaseFirestore.instance
                    .collection("category")
                    .orderBy("name")
                    .snapshots(),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                applyFiltersToList();
              }, child: const Text("Appliquer")),
              const SizedBox(
                width: 20,
              ),
              const ElevatedButton(onPressed: null, child: Text("Reset")),
            ],
          ),
        ]))));
  }

  Widget buildCategoryChips(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      var chips = <Widget>[];
      for (var element in snapshot.data!.docs) {
        GrimmCategory grimmCategory = GrimmCategory.fromJson(element);
        if (firstbuild) {
          categoryStatus.putIfAbsent(grimmCategory.id, () => 1);
        }
        chips.add(FilterChip(
          selected: (categoryStatus[grimmCategory.id] == 1) ? true : false,
          label: Text(grimmCategory.name),
          onSelected: (bool value) {
            setState(() {
              if (categoryStatus[grimmCategory.id] == 1) {
                categoryStatus[grimmCategory.id] = 0;
              } else {
                categoryStatus[grimmCategory.id] = 1;
              }
            });
          },
        ));
      }
      firstbuild = false;

      var size = MediaQuery.of(context).size;
      final double itemHeight = (size.height - kToolbarHeight - 24) / 10;
      final double itemWidth = size.width / 2;
      return Container(
          margin: new EdgeInsets.all(1.0),
          child: GridView.count(
            childAspectRatio: (itemWidth / itemHeight),
            shrinkWrap: true,
        crossAxisCount: 3,
            scrollDirection: Axis.vertical,
        children: chips,
      ));
    } else {
      return const Text("Pas de catégorie pour filtrer.");
    }
  }

  void applyFiltersToList() {
    print(categoryStatus);
    bool? objectStatus;
    if(available && !borrowed) {
      print("only available");
      objectStatus = true;
    } else if(!available && borrowed) {
      print("only borrowed");
      objectStatus = false;
    }
    List categoryToDisplay = [];
    categoryStatus.forEach((key, value) {
      if(value == 1) {
        categoryToDisplay.add(key);
      }
    });
    print(categoryToDisplay.length);
    print(categoryStatus.length);

    if(categoryToDisplay.length < 10 || categoryStatus.length == categoryToDisplay.length) {
      if(categoryStatus.length == categoryToDisplay.length) {
        categoryToDisplay = [];
      }
      refresh(objectStatus, categoryToDisplay);
      Navigator.of(context).pushReplacementNamed(ItemsAdmin.routeName, arguments: {'role': role, 'available': available});
      Navigator.of(context).pop();
    }
  }
}
