/*
* Classe pour l'écran de création d'un nouveau compte 
* Lié directement avec la firebase Authentification
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  static const routeName = '/create_account';

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  bool isServiceProvider = false; // TODO : gérer le serviceProvider
  final _key = GlobalKey<FormState>();
  //final AuthentificationService _auth = AuthentificationService(); // app du service d'autentification pour ensuite appeler la méthode signIn()
  
  bool isChecked = false;
  bool isUploading = false;
  TextEditingController pseudoController = TextEditingController(); // controlleur du username
  TextEditingController emailController = TextEditingController(); // controlleur du email
  TextEditingController passwordController = TextEditingController();// controlleur du password
  //String userId = Uuid().v4();

  @override
  void initState() {
    super.initState();
  }



 /* createUserInFirestore({required String pseudo, required String email, required String password}){

    usersRef
        .add({
   //   "id" : userId,
      "username": pseudo,
      "email" : email,
      "password" : password,
      "isServiceProvider" : false,
      "isSubscribed" : false,
    });
  }

  handleSubmit() {
    setState((){
      isUploading = true;
    });

    createUserInFirestore(
      pseudo: pseudoController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    pseudoController.clear();
    emailController.clear();
    passwordController.clear();
    setState((){
      isUploading = false;
      userId = Uuid().v4();
    });
  }*/

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(50),
          children: <Widget>[
            //isUploading ? linearProgress() : Text(""),
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
              controller: pseudoController,
              validator: (value) {
                          if (value == null) {
                            return 'Prénom ne peut pas etre vide';
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
              controller: pseudoController,
              validator: (value) {
                          if (value == null) {
                            return 'Nom ne peut pas etre vide';
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
                          if (value == null) {
                            return 'Email ne peut pas etre vide';
                          } else
                            return null;
                        },
              decoration: InputDecoration(
                labelText: 'Adresse mail',
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
              controller: passwordController,
               validator: (value) {
                          if (value == null) {
                            return 'Mot de passe ne peut pas etre vide';
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
            TextFormField(
              controller: pseudoController,
              validator: (value) {
                          if (value == null) {
                            return 'Groupe ne peut pas etre vide';
                          } else
                            return null;
                        },
              decoration: InputDecoration(
                labelText: 'Groupe',
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).backgroundColor,
                textStyle: TextStyle(fontFamily: "Raleway-Regular",
                  fontSize: 14.0)
              ),
                 onPressed: () async { /*// ici on gère si l'entrée est valide ou non et on crée le User, puis le modelUser
                              if (_key.currentState!.validate()) {
                                ModelUser modelUser = ModelUser(
                                    username: pseudoController.text,
                                    email: emailController.text,
                                    isServiceProvider: isServiceProvider);
                                Object? result = await _auth.signUp(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    modelUser: modelUser);
                                if (result is ModelUser) {
                                  print("User CREATE" + result.toString());
                                  Navigator.of(context).pushNamed('/eventslist_screen');;
                                } else {
                                    // gérer l'erreur
                                }
                              } */ 
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


    Widget buildServiceProvider() => Transform.scale(
        scale: 1,
        child: Switch(
          value: isServiceProvider,
          onChanged: (value) => setState(() => this.isServiceProvider = value),
        ),
      );
}

