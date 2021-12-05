/*
* Classe pour l'écran de création d'un nouveau compte 
* Lié directement avec la firebase Authentification
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/pages/home.dart';
import 'package:grimm_scanner/service/authentication_service.dart';

import 'accounts_admin.dart';


class CreateAccountScreen extends StatefulWidget {
  static const routeName = '/create_account';

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  final _key = GlobalKey<FormState>();
  final AuthenticationService _auth =
      AuthenticationService(); // app du service d'autentification pour ensuite appeler la méthode signIn()

  bool isAdmin = false;
  bool isObjectManager = false;
  bool isMember = false;

  TextEditingController lastnameController =
      TextEditingController(); // controlleur du name
  TextEditingController firstnameController =
      TextEditingController(); // controlleur du prenom
  TextEditingController emailController =
      TextEditingController(); // controlleur du email
  TextEditingController passwordController =
      TextEditingController(); // controlleur du password
  TextEditingController groupController =
      TextEditingController(); // controlleur du group

  @override
  void initState() {
    super.initState();
  }

  var errorMessage = "";

  void changeErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Création d'un compte"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(50),
          children: <Widget>[
            const Text(
              "Créez un nouvel utilisateur",
              style: TextStyle(
                fontFamily: "Raleway-Regular",
                fontSize: 30.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: firstnameController,
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
              height: 20,
            ),
            TextFormField(
              controller: lastnameController,
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
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le champ "Email" ne peut pas être vide';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontFamily: "Raleway-Regular",
                  fontSize: 14.0,
                  color: Colors.black,
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
              cursorColor: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le champ "Mot de passe" ne peut pas être vide';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(
                  fontFamily: "Raleway-Regular",
                  fontSize: 14.0,
                  color: Colors.black,
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
              cursorColor: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            CheckboxListTile(
              title: const Text("Administrateur"),
              tileColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              activeColor: Colors.black,
              value: isAdmin,
              onChanged: (bool? value) {
                setState(() {
                  isAdmin = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Responsable inventaire"),
              tileColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              activeColor: Colors.black,
              value: isObjectManager,
              onChanged: (bool? value) {
                setState(() {
                  isObjectManager = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Membre"),
              tileColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              activeColor: Colors.black,
              value: isMember,
              onChanged: (bool? value) {
                setState(() {
                  isMember = value!;
                });
              },
            ),
            const SizedBox(
              height: 20,
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
                  // ici on gère si l'entrée est valide ou non et on crée le User, puis le modelUser
                  var tab = [];
                  if (isAdmin) {
                    tab.add("Administrator");
                  }
                  if (isMember) {
                    tab.add("Member");
                  }
                  if (isObjectManager) {
                    tab.add("ObjectManager");
                  }
                  User _user = FirebaseAuth.instance.currentUser!;
                  print("BEFORE");
                  print(_user);
                  if (tab.isNotEmpty) {
                    if (_key.currentState!.validate()) {
                      GrimmUser grimmUser = GrimmUser(
                          name: lastnameController.text,
                          firstname: firstnameController.text,
                          email: emailController.text,
                          groups: tab);
                      Object? result = await _auth.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          grimmUser: grimmUser);
                      if (result is GrimmUser) {
                        //print("User CREATE" + result.toString());
                        changeErrorMessage("");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Compte créé avec succès")));
                        print("AFTER");
                        User _user = FirebaseAuth.instance.currentUser!;
                        print(_user);
                       Navigator.pushNamed(context, Home.routeName);
                       // Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Veuillez modifier votre mail/mot de passe")));
                        changeErrorMessage(result.toString());
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Veuillez sélectionner un groupe au minimum.")));
                  }
                },
                child: const Text("VALIDER")),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
