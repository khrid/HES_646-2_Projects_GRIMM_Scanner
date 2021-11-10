import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_user.dart';

import 'accounts_user_detail.dart';
import 'create_account.dart';

class AccountsAdmin extends StatefulWidget {
  static const routeName = "/accounts/admin";

  const AccountsAdmin({Key? key}) : super(key: key);

  @override
  _AccountsAdminState createState() => _AccountsAdminState();
}

class _AccountsAdminState extends State<AccountsAdmin> {
  late GrimmUser selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion des utilisateurs"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: createUser,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .orderBy("name")
                      .snapshots(),
                  builder: buildUsersList,
                ))
      //drawer: const CustomDrawer(),
    );
  }

  Future<void> createUser() async {
   setState(() {
         Navigator.pushNamed(context, CreateAccountScreen.routeName);
       });
  }

  Widget buildUsersList(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Column(children: <Widget>[
        ListView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            GrimmUser grimmUser = GrimmUser.fromJson(doc);
            print(grimmUser);
            return Card(
              child: ListTile(
                  minLeadingWidth: 10,
                  horizontalTitleGap: 10,
                  title: Text(grimmUser.name + " " + grimmUser.firstname),
                  onTap: () {
                    Navigator.pushNamed(context, UserDetail.routeName,
                        arguments: grimmUser.uid);
                  }
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
