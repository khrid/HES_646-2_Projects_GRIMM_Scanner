import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/service/authentication_service.dart';
import 'package:grimm_scanner/widgets/button_home.dart';
import 'package:provider/provider.dart';

class LoginGroup extends StatefulWidget {
  static const routeName = '/login/group';
  const LoginGroup({Key? key}) : super(key: key);


  @override
  _LoginGroupState createState() => _LoginGroupState();
}

class _LoginGroupState extends State<LoginGroup> {
  final AuthenticationService _auth = AuthenticationService();
  late String role;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GrimmUser?>(context);
    print("testLoginGroupPage");
    print(user);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Choix du rôle"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: makeLogout,
          child: Icon(
            Icons.logout,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (user!.groups.contains("Administrator"))
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  fixedSize: const Size(250, 100),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                  ),
                  padding: EdgeInsets.all(20.0),
                ),
                onPressed: () async {
                  {
                    role = "Administrator";
                    Navigator.pushNamed(context, Home.routeName, arguments: role);
                  }
                },
                child: Text("Administrateur")),
                const SizedBox(
                  height: 10.0,
                ),
                if (user.groups.contains("ObjectManager"))
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  fixedSize: const Size(250, 100),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                  ),
                  padding: EdgeInsets.all(20.0),
                ),
                onPressed: () async {
                  {
                    role = "ObjectManager";
                    Navigator.pushNamed(context, Home.routeName, arguments: role);
                  }
                },
                child: Text("Object Manager")),
                const SizedBox(
                  height: 10.0,
                ),
                if (user.groups.contains("Member"))
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  fixedSize: const Size(250, 100),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                  ),
                  padding: EdgeInsets.all(20.0),
                ),
                onPressed: () async {
                  {
                    role = "Member";
                    Navigator.pushNamed(context, Home.routeName, arguments: role);
                  }
                },
                child: Text("Membre")),              
              ],
            ),
          ],
        ))));
  }


    /*Future<void> navigateToHomePage(String role) async {
    setState(() {
      Navigator.pushNamed(context, Home.routeName, arguments: role);
    });
  }*/

  makeLogout() async {
    await _auth.signOut();
    Navigator.pop(context);
    print('Out');
    }

  Future<void> navigateToHomePage() async {
    setState(() {
      Navigator.pushNamed(context, Home.routeName);
    });
  }
}





