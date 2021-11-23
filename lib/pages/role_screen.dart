import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/widgets/button_home.dart';
import 'package:provider/provider.dart';

class RoleScreen extends StatefulWidget {
  static const routeName = '/role_screen';
  const RoleScreen({Key? key}) : super(key: key);

  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
   late GrimmUser user;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GrimmUser?>(context);
    print(user);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Choix du rôle"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
            child: SingleChildScrollView(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                 /*StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .snapshots(),
                builder: buildUserButton,
              ),*/
                CustomHomeButton(
                    title: user!.uid,
                    onPressed: navigateToHome),
                const SizedBox(
                  height: 10.0,
                ),
                CustomHomeButton(
                    title: "Membre",
                    onPressed: navigateToHome)
              ],
            ),
          ],
        )))
        );
  }

  Future<void> navigateToHome() async {
    setState(() {
      Navigator.pushNamed(context, Home.routeName);
    });
  }



  /*Widget buildUserButton2(BuildContext context,
    AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  // snapshot.hasData renvoie true même si le doc n'existe pas, il faut tester
                  // encore plus loin pour être sûr
                  // si on a des données et que le doc existe
                  if (snapshot.data != null) {
                    List<String> groups = [];

                    for (var result in snapshot.data!.docs) {
                    return ElevatedButton(onPressed: onPressed, child: child);
                    }

                    
              }}}
          



  Widget buildUserButton(BuildContext context,
    AsyncSnapshot<DocumentSnapshot> snapshot) {
    bool isAdmin = false;
    bool isObjectManager = false;
    bool isMember = false;
          
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        user = GrimmUser.fromJson(snapshot.data);
        if (user.groups.contains("Administrator")) isAdmin = true;
        if (user.groups.contains("Member")) isMember = true;
       if (user.groups.contains("ObjectManager")){isObjectManager = true;}

        return  ElevatedButton(
            onPressed: () async {
            },
            child: Text("text", textAlign: TextAlign.center),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              side: const BorderSide(width: 1.0, color: Colors.black),
              fixedSize: const Size(250, 100),
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 28.0,
              ),
              padding: EdgeInsets.all(20.0),
            ),
          );}
    }}*/

}