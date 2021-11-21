import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/widgets/button_home.dart';
import 'package:provider/provider.dart';

class LoginGroup extends StatefulWidget {
  static const routeName = '/login/group';
  const LoginGroup({Key? key}) : super(key: key);

  @override
  _LoginGroupState createState() => _LoginGroupState();
}

class _LoginGroupState extends State<LoginGroup> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GrimmUser?>(context);
    print("testLoginGroupPage");
    print(user);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Choice"),
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
                if (user!.groups.contains("Administrator"))
                  CustomHomeButton(
                      title: "Administrator", onPressed: navigateToHomePage),
                const SizedBox(
                  height: 10.0,
                ),
                if (user!.groups.contains("ObjectManager"))
                  CustomHomeButton(
                      title: "Object Manager", onPressed: navigateToHomePage),
                const SizedBox(
                  height: 10.0,
                ),
                if (user!.groups.contains("Member"))
                  CustomHomeButton(
                      title: "Member", onPressed: navigateToHomePage)
              ],
            ),
          ],
        ))));
  }

  Future<void> navigateToHomePage() async {
    setState(() {
      Navigator.pushNamed(context, Home.routeName);
    });
  }
}
