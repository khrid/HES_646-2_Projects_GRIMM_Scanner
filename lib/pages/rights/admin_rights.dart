import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_right.dart';
import 'package:grimm_scanner/pages/rights/admin_rights_detail.dart';


class RightsAdmin extends StatefulWidget {
  static const routeName = "/admin/rightsadmin";

  const RightsAdmin({Key? key}) : super(key: key);

  @override
  _RightsAdminState createState() => _RightsAdminState();
}

class _RightsAdminState extends State<RightsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion des droits"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
       body: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("rights")
              .snapshots(),
          builder: buildRightsList,
        ))
                          //drawer: const CustomDrawer(),
                          );
                    }
}

 Widget buildRightsList(
    BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Column(children: <Widget>[
        ListView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            GrimmRight grimmRight = GrimmRight.fromJson(doc);
            return Card(
              child: ListTile(
                  minLeadingWidth: 10,
                  horizontalTitleGap: 10,
                  title: Text(grimmRight.description),
                  onTap: () {
                    //print("GRIMM RIGHT ID"+ grimmRight.id);
                    Navigator.pushNamed(context, RightsAdminDetail.routeName,
                        arguments: grimmRight.id);
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
