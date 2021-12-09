import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
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
  late var tmpCat = [];
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

    if (firstbuild) {
      final arguments = [];
      arguments
          .addAll(ModalRoute.of(context)!.settings.arguments as LinkedHashSet);
      print(arguments.elementAt(3).runtimeType);
      role = arguments.elementAt(0);
      refresh = arguments.elementAt(1);
      bool? temp = arguments.elementAt(2);
      tmpCat = arguments.elementAt(3);
      for (var element in tmpCat) {
        categoryStatus.putIfAbsent(element, () => 1);
      }

      print(tmpCat);

      if (temp == null) {
        setState(() {
          available = true;
          borrowed = true;
        });
      } else {
        if (temp) {
          setState(() {
            borrowed = false;
          });
        } else {
          setState(() {
            available = false;
          });
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Filtrer"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Center(
                child: Column(children: [
              Text(getTranslated(context, "availability")!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
                       const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    selected: available,
                    label: Text(getTranslated(context, "available")!),
                    labelStyle: TextStyle(
                    color: available ? Colors.white : Colors.black),
                    onSelected: (bool value) {
                      setState(() {
                        available = !available;
                      });
                    },
                    elevation: 4,
                    selectedColor: Colors.black,
                    selectedShadowColor: Colors.black,
                    backgroundColor: Theme.of(context).primaryColor,
                    checkmarkColor: Colors.white
                  ),
                 const SizedBox(
                    width: 20,
                  ),
                  FilterChip(
                    selected: borrowed,
                    label: Text(getTranslated(context, "unavailable")!),
                     labelStyle: TextStyle(
                    color: borrowed ? Colors.white : Colors.black),
                    onSelected: (bool value) {
                      setState(() {
                        borrowed = !borrowed;
                      });
                    },
                    elevation: 4,
                    selectedColor: Colors.black,
                    selectedShadowColor: Colors.black,
                    backgroundColor: Theme.of(context).primaryColor,
                    checkmarkColor: Colors.white
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(getTranslated(context, "category")!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              
               const SizedBox(
                height: 20,
              ),Wrap(
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
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(
                      fontFamily: "Raleway-Regular", fontSize: 14.0),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  padding: const EdgeInsets.only(top: 10, right: 50, left: 50, bottom: 10),
                ),
                      onPressed: () {
                        applyFiltersToList();
                      },
                      child: Text(getTranslated(context, "apply")!)),
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
          if (tmpCat.isNotEmpty) {
            categoryStatus.putIfAbsent(grimmCategory.id, () => 0);
          } else {
            categoryStatus.putIfAbsent(grimmCategory.id, () => 1);
          }
        }
        bool isSelected ;
        isSelected =(categoryStatus[grimmCategory.id] == 1) ? true : false;
        chips.add(FilterChip(
          elevation: 4,
                    selectedColor: Colors.black,
                    selectedShadowColor: Colors.black,
                    backgroundColor: Theme.of(context).primaryColor,
                    checkmarkColor: Colors.white,
          selected: (categoryStatus[grimmCategory.id] == 1) ? true : false,
          label: Text(grimmCategory.name),
          labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black),
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
      final double itemHeight = (size.height - kToolbarHeight - 24) / 15;
      final double itemWidth = size.width / 2;
      return Container(
          margin: const EdgeInsets.all(1.0),
          child: GridView.count(
            childAspectRatio: (itemWidth / itemHeight),
            shrinkWrap: true,
            crossAxisCount: 2,
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
    if (available && !borrowed) {
      print("only available");
      objectStatus = true;
    } else if (!available && borrowed) {
      print("only borrowed");
      objectStatus = false;
    } else {
      objectStatus = null;
    }
    print(objectStatus);
    List categoryToDisplay = [];
    categoryStatus.forEach((key, value) {
      if (value == 1) {
        categoryToDisplay.add(key);
      }
    });
    print(categoryToDisplay.length);
    print(categoryStatus.length);

    if (categoryToDisplay.length < 10 ||
        categoryStatus.length == categoryToDisplay.length) {
      if (categoryStatus.length == categoryToDisplay.length) {
        categoryToDisplay = [];
      }
      refresh(objectStatus, categoryToDisplay);
      Navigator.of(context).pushReplacementNamed(ItemsAdmin.routeName,
          arguments: {'role': role, 'available': available});
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              getTranslated(context, 'snackbar_error_max_10_cat_or_all')!)));
    }
  }
}
