import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/account/update_account.dart';

class UserDetail extends StatefulWidget {
  static const routeName = "/users/detail";

  const UserDetail({Key? key}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late GrimmUser user;

  @override
  Widget build(BuildContext context) {
    String userUID;
    userUID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_user_admin')!),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: editUser,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userUID)
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
    //print(snapshot.data);
    bool isAdmin = false;
    bool isObjectManager = false;
    bool isMember = false;

    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        user = GrimmUser.fromJson(snapshot.data);
        print(" --- " + jsonEncode(snapshot.data!.data().toString()));
        String status;
        if (user.enable == true) {
          status = getTranslated(context, 'active')!;
        } else {
          status = getTranslated(context, 'inactive')!;
        }
        //print(user);
        if (user.groups.contains("Administrator")) isAdmin = true;
        if (user.groups.contains("Member")) isMember = true;
        if (user.groups.contains("ObjectManager")) isObjectManager = true;

        return Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            getTranslated(context, 'info')!,
            style: const TextStyle(
              fontFamily: "Raleway-Regular",
              fontSize: 30.0,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          Text(getTranslated(context, 'name')! + user.name,
              style: const TextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 20.0),
          Text(getTranslated(context, 'firstname')! + user.firstname,
              style: const TextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 20.0),
          Text(getTranslated(context, 'email')! + user.email,
              style: const TextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 20.0),
          Text(getTranslated(context, 'status')! + status,
              style: const TextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 20.0),
          CheckboxListTile(
              title: Text(getTranslated(context, 'administrator')!),
              tileColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              activeColor: Colors.black,
              value: isAdmin,
              onChanged: null),
          CheckboxListTile(
            title: Text(getTranslated(context, 'objectManager')!),
            tileColor: Theme.of(context).primaryColor,
            checkColor: Colors.white,
            activeColor: Colors.black,
            value: isObjectManager,
            onChanged: null,
          ),
          CheckboxListTile(
            title: Text(getTranslated(context, 'membre')!),
            tileColor: Theme.of(context).primaryColor,
            checkColor: Colors.white,
            activeColor: Colors.black,
            value: isMember,
            onChanged: null,
          ),
          const SizedBox(
            height: 20,
          ),
        ]));
      } else {
        return Text(getTranslated(context, 'error_users_not_found')!);
      }
    }
    return Text(getTranslated(context, 'error_users_not_found')!);
  }

  Future<void> editUser() async {
    setState(() {
      Navigator.pushNamed(context, UserUpdate.routeName, arguments: user);
    });
  }
}
