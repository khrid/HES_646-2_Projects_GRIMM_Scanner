import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/models/grimm_category.dart';
import 'package:grimm_scanner/pages/categories/edit_category.dart';
import 'package:grimm_scanner/widgets/action_button.dart';
import 'package:grimm_scanner/widgets/expandable_fab.dart';

class CategoryDetail extends StatefulWidget {
  static const routeName = "/items/categories/detail";

  const CategoryDetail({Key? key}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {

  late GrimmCategory category;

  late final CollectionReference _categories =
  FirebaseFirestore.instance.collection("category");

  late final CollectionReference _items =
  FirebaseFirestore.instance.collection("items");

  @override
  Widget build(BuildContext context) {
    var categoryID;
    categoryID = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    print(categoryID);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catégorie"),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      floatingActionButton:
      ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: editCategory,
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => showAlertDialog(context),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
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
                    .collection('category')
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

  Widget buildUserDetails(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    print(snapshot.data);

    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        category = GrimmCategory.fromJson(snapshot.data);
        String status;
        print(category);

        return Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nom de la catégorie :",
                  style: TextStyle(
                      fontFamily: "Raleway-Regular",
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,),
                  const SizedBox(height: 20.0),
                  Text(category.name,
                    style: TextStyle(
                      
                      fontFamily: "Raleway-Regular",
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center),
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continuer"),
      onPressed: () {
        category.updateItemsDeletedCategory();
        _categories.doc(category.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Catégorie supprimée'),
            duration: Duration(seconds: 2)));
        var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suppression de la catégorie"),
      content: Text("Êtes-vous vraiment sûr de vouloir supprimer cette catégorie ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}