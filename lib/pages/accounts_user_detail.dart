import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/update_account.dart';

class UserDetail extends StatefulWidget {
  static const routeName = "/users/detail";

  const UserDetail({Key? key}) : super(key: key);
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    var userUID;
    userUID = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    print(userUID);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Détails de l'utilisateur"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        body: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                )
            )
    );
  }

  Widget buildUserDetails(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.data!.data() != null) {
      GrimmUser user = GrimmUser.fromJson(snapshot.data);
      //print(user.uid);
      return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informations de l'utilisateur",
                  style: TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                Text("Nom : " + user.name,
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(height: 20.0),
                Text("Prénom : " + user.firstname,
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(height: 20.0),
                Text("Email : " + user.email,
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(height: 20.0),
                //Text("Compte actif : " + user.enable.toString(),
                //    style: TextStyle(color: Colors.black, fontSize: 14)),
                //const SizedBox(height: 20.0),
                MaterialButton(
                  color: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, UserUpdate.routeName,
                        arguments: user);
                  },
                  child: Text(
                    "Edit user",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                /*MaterialButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Delete user",
                    style: TextStyle(color: Colors.white),
                  ),
                )*/
              ]
          )
      );
    } else {
      return Text(
          "Pas d'utilisateur trouvé, erreur. Veuillez contacter les développeurs");
    }
  }
}