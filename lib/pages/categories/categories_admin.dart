import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_category.dart';
import 'categories_detail.dart';

class CategoriesAdmin extends StatefulWidget {
  static const routeName = "/items/categories";

  const CategoriesAdmin({Key? key}) : super(key: key);

  @override
  _CategoriesAdminState createState() => _CategoriesAdminState();
}

class _CategoriesAdminState extends State<CategoriesAdmin> {
  TextEditingController categoryNameController =
      TextEditingController(); // controlleur de la description

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'appbar_category_admin')!),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => openDialog(context),
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("category")
              .orderBy("name")
              .snapshots(),
          builder: buildCategoriesList,
        )));
  }

  openDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(getTranslated(context, 'button_cancel')!),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
        child: Text(getTranslated(context, 'button_confirm')!),
        onPressed: () {
          GrimmCategory category =
              GrimmCategory(name: categoryNameController.text);
          category.saveToFirestore();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              getTranslated(context, 'category_add')!,
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF1CB731),
          ));
          var nav = Navigator.of(context);
          nav.pop();
          setState(() {});
        }
        //}
        );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(getTranslated(context, 'category_new')!),
      content: TextFormField(
          controller: categoryNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return getTranslated(context, 'error_category_empty')!;
            } else {
              return null;
            }
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              hintText: getTranslated(context, 'category_field_new')!)),
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

  Widget buildCategoriesList(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Column(children: <Widget>[
        ListView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            GrimmCategory grimmCategory = GrimmCategory.fromJson(doc);
            return Card(
              child: ListTile(
                  minLeadingWidth: 10,
                  horizontalTitleGap: 10,
                  title: Text(grimmCategory.name),
                  onTap: () {
                    Navigator.pushNamed(context, CategoryDetail.routeName,
                        arguments: grimmCategory.id);
                  }),
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
