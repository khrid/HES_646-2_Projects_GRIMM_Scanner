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
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(userEmailController.text);
                    if (_formKey.currentState!.validate()) {
                      if (emailValid == true) {
                        user.email = userEmailController.text;
                        _changeMail(userEmailController.text);
                        updateUser(user);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              "Mise à jour du profil réussie",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 5),
                            backgroundColor: Color(0xFF1CB731),
                          ));
                      Navigator.pop(context);
                      } else {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              "Erreur dans la saisie de votre adresse mail.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 5),
                            backgroundColor: Color(0xFFB71C1C),
                          ));}
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              "Erreur lors de la mise à jour du profil.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 5),
                            backgroundColor: Color(0xFFB71C1C),
                          ));
                    }
                  },
                  child: const Text("Valider les modifications")),
            ])));
  }

  Future<void> updateUser(GrimmUser u) async {
    u.updateFirestore();
  }

  void _changeMail(String newEmail) async {
    User _user = FirebaseAuth.instance.currentUser!;
    _user.updateEmail(newEmail);
  }
}
