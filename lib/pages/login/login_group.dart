import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/pages/login/login.dart';
import 'package:grimm_scanner/service/authentication_service.dart';
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
    
    if (user!.enable == false) 
    {
      makeLogout();
    }



    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'appbar_choose_role')!),
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
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/logo_grimm_black.jpg"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.05), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                if (user.groups.contains("Administrator"))
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        side: const BorderSide(width: 1.0, color: Colors.black),
                        fixedSize: const Size(250, 100),
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                        ),
                        padding: const EdgeInsets.all(20.0),
                      ),
                      onPressed: () async {
                        {
                          role = "Administrator";
                          Navigator.pushNamed(context, Home.routeName,
                              arguments: role);
                        }
                      },
                      child: Text(getTranslated(context, 'administrator')!,
                      textAlign:TextAlign.center),),
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
                        padding: const EdgeInsets.all(20.0),
                      ),
                      onPressed: () async {
                        {
                          role = "ObjectManager";
                          Navigator.pushNamed(context, Home.routeName,
                              arguments: role);
                        }
                      },
                      child: Text(getTranslated(context, 'objectManager')!,
                      textAlign:TextAlign.center), ),
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
                        padding: const EdgeInsets.all(20.0),
                      ),
                      onPressed: () async {
                        {
                          role = "Member";
                          Navigator.pushNamed(context, Home.routeName,
                              arguments: role);
                        }
                      },
                      child: Text(getTranslated(context, 'membre')!,
                      textAlign:TextAlign.center),),
              ])
            ],
          ),
        ));
  }

  makeLogout() async {
    await _auth.signOut();
     //Navigator.pushNamed(context, '/');
     Navigator.pop(context, '/');
    //print('Out');
  }

  Future<void> navigateToHomePage() async {
    setState(() {
      Navigator.pushNamed(context, Home.routeName);
    });
  }
}
