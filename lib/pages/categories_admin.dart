import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/models/grimm_category.dart';

class CategoriesAdmin extends StatefulWidget {
  static const routeName = "/items/categories";

  const CategoriesAdmin({Key? key}) : super(key: key);

  @override
  _CategoriesAdminState createState() => _CategoriesAdminState();
}

class _CategoriesAdminState extends State<CategoriesAdmin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion des catégories"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => openDialog(context),
          child: Icon(Icons.add,
            color: Theme
                .of(context)
                .primaryColor,),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("cats")
                  .orderBy("name")
                  .snapshots(),
              builder: buildCategoriesList,
            ))
      //drawer: const CustomDrawer(),
    );
  }


  openDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirmer"),
      onPressed: () {
        //_categories.doc(category.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Objet supprimé'),
            duration: Duration(seconds: 2)));
        var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Nouvelle catégorie :'),
      content: TextField(
          decoration: InputDecoration(
              hintText: 'Entrez la nouvelle catégorie'
          )
      ),
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


  Widget buildCategoriesList(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Column(children: <Widget>[
        ListView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            GrimmCategory grimmCategory = GrimmCategory.fromJson(doc);
            //grimmUser.setUid(doc.id);
            //print();
            return Card(
              child: ListTile(
                  minLeadingWidth: 10,
                  horizontalTitleGap: 10,
                  title: Text(grimmCategory.name),
                  onTap: () {}
              ),
            );
          }).toList(),
        )
      ]);
    } else {
      return const Center (
        child: CircularProgressIndicator(),
      );
    }
  }
}
