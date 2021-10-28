/*
* Classe pour l'écran de création d'un nouveau compte 
* Lié directement avec la firebase Authentification
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/service/AuthenticationService.dart';

class CreateAccountScreen extends StatefulWidget {
  static const routeName = '/create_account';

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  final _key = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService(); // app du service d'autentification pour ensuite appeler la méthode signIn()
  
  bool isAdmin = false;
  bool isObjectManager = false;
  bool isMember = false;

  TextEditingController lastnameController = new TextEditingController(); // controlleur du name
  TextEditingController firstnameController = new TextEditingController(); // controlleur du prenom
  TextEditingController emailController = new TextEditingController();// controlleur du email
  TextEditingController passwordController = new TextEditingController();// controlleur du password
  TextEditingController groupController = new TextEditingController();// controlleur du group


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
          padding: EdgeInsets.all(50),
          children: <Widget>[
            Text(
              "Créez un nouvel utilisateur",
              style: TextStyle(
                fontFamily: "Raleway-Regular",
                fontSize: 30.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: firstnameController,
              validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le champ "Prénom" ne peut pas être vide';
                          } else
                            return null;
                        },
              decoration: InputDecoration(
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: lastnameController,
              validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le champ "Nom" ne peut pas être vide';
                          } else
                            return null;
                        },
              decoration: InputDecoration(
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
               validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le champ "Email" ne peut pas être vide';
                          } else
                            return null;
                        },
              decoration: InputDecoration(
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
               validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le champ "Mot de passe" ne peut pas être vide';
                          } else
                            return null;
                        },
              decoration: InputDecoration(
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
            SizedBox(
              height: 20,
            ),
            CheckboxListTile(
              title: Text("Administrateur"),
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
              title: Text("Manager d'objets"),
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
              title: Text("Membre"),
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(fontFamily: "Raleway-Regular",
                  fontSize: 14.0),
                side: const BorderSide(width: 1.0, color: Colors.black),
                padding: EdgeInsets.all(20.0),

              ),
                 onPressed: () async { // ici on gère si l'entrée est valide ou non et on crée le User, puis le modelUser
                              //TODO : amélioration possible, code pas ouf mais ça fonctionne
                              var tab = [];
                              if (isAdmin) {
                                tab.add("Administrateur");                                
                              } 
                              if (isMember) {
                                tab.add("Membre");                                
                              } 
                              if (isObjectManager) {
                                tab.add("ObjectManager");                                
                              } 
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
                                  print("User CREATE" + result.toString());
                                  changeErrorMessage("");
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Compte créé avec succès")));
                                  Navigator.pushNamed(
                                      context, "/");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Veuillez modifier votre mail/mot de passe")));
                                  changeErrorMessage(result.toString());
                                }
                              }  
                            },          
                            child: Text("VALIDER")),   
            SizedBox(
              height: 20,
            ),
      
          ],
        ),
      ),
    );
  }



}

