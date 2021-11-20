import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/models/grimm_category.dart';
import 'package:grimm_scanner/pages/edit_category.dart';

import 'edit_item.dart';

class CategoryDetail extends StatefulWidget {
  static const routeName = "/items/categories/detail";

  const CategoryDetail({Key? key}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {

  late GrimmCategory category;

  @override
  Widget build(BuildContext context) {
    var categoryID;
    categoryID = ModalRoute.of(context)!.settings.arguments as String;
    print(categoryID);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catégorie"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: editCategory,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,),
      ),
      body:
      Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cats')
                    .doc(categoryID)
                    .snapshots(),
                builder: buildUserDetails,
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );

  }

  Widget buildUserDetails(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    print(snapshot.data);

    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        category = GrimmCategory.fromJson(snapshot.data);
        String status;
        print(category);

        return Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Nom de la catégorie: " + category.name,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                  const SizedBox(height: 20.0),
                ]));
      } else {
        return Text(
            "Pas de catégorie trouvée, erreur. Veuillez contacter les développeurs");
      }
    }
    return Text(
        "Pas de catégorie trouvée, erreur. Veuillez contacter les développeurs");
  }

  Future<void> editCategory() async {
    setState(() {
      Navigator.pushNamed(context, CategoryUpdate.routeName,
          arguments: category);
    });
  }


}
