import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:provider/provider.dart';

class ProfileAdmin extends StatefulWidget {
  static const routeName = "/profile";

  const ProfileAdmin({Key? key}) : super(key: key);

  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  final _formKey = GlobalKey<FormState>();
  late bool _passwordVisible;
  late String role;
  late GrimmUser user;
  late String userUID;

  TextEditingController userNameController = TextEditingController();
  TextEditingController userSurnameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GrimmUser?>(context);
    role = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as String;
    if (role == "NULL") {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false));
    }

    userNameController.text = user!.name;
    userSurnameController.text = user.firstname;
    userEmailController.text = user.email;
    userPasswordController.text = " ";

    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion du profil"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Form(
            key: _formKey,
            child:
                ListView(padding: const EdgeInsets.all(50), children: <Widget>[
              const Text(
                "Modifiez les informations de votre profil",
                style: TextStyle(
                  fontFamily: "Raleway-Regular",
                  fontSize: 30.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: userSurnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le champ "Prénom" ne peut pas être vide';
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  labelStyle: TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).backgroundColor,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: userNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le champ "Nom" ne peut pas être vide';
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).backgroundColor,
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: userEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                cursorColor: Colors.black,
                enabled: true,
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: userPasswordController,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: const TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                cursorColor: Colors.black,
                enabled: true,
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: const TextStyle(
                        fontFamily: "Raleway-Regular", fontSize: 14.0),
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    padding: const EdgeInsets.all(20.0),
                  ),
                  onPressed: () async {
                    user.name = userNameController.text;
                    user.firstname = userSurnameController.text;
                    user.email = userEmailController.text;
                    if (_formKey.currentState!.validate()) {
                      updateUser(user);
                      _changePassword(userPasswordController.text);
                      _changeMail(userEmailController.text);
                      //("Changements effectués");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Modifications réussies",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 5),
                        backgroundColor: Color(0xFF1CB731),
                      ));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Erreur lors de la création.")));
                    }
                  },
                  child: const Text("Valider les modifications")),
            ])));
    //drawer: const CustomDrawer(),
  }

  Future<void> updateUser(GrimmUser u) async {
    u.updateFirestore();
  }

  void _changePassword(String password) async {
//Create an instance of the current user.
    User user = FirebaseAuth.instance.currentUser!;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  void _changeMail(String newEmail) async {
//Create an instance of the current user.
    User _user = FirebaseAuth.instance.currentUser!;
    //Pass in the password to updatePassword.
    _user.updateEmail(newEmail).then((_) {
      print("Successfully changed email");
    }).catchError((error) {
      print("email can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
