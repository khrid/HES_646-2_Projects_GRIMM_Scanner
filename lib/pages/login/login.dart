import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/models/language.dart';
import 'package:grimm_scanner/pages/login/login_group.dart';
import 'package:grimm_scanner/service/authentication_service.dart';

import '../../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController emailController = TextEditingController(
      text: "bretzlouise@gmail.com"); // texte ajouté pour facilité le travail
  //text: ""); // texte ajouté pour facilité le travail
  TextEditingController passwordController =
      TextEditingController(text: "123456");

  MenuScreen(BuildContext context) {
    setState(() {
      Navigator.pushNamed(context, LoginGroup.routeName);
    });
  }

  Language? selectedLanguage = Language.getDefaultLanguage();

  void _changeLanguage(Language language) async {
    selectedLanguage = language;
    Locale _locale = await setLocale(language.languageCode);
    App.setLocale(context, _locale);
  }

  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(top: 0, right: 40, left: 40),
          children: <Widget>[
            Image.asset(
              'assets/images/logo_grimm.png',
              width: 200,
              height: 200,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              getTranslated(context, 'title')!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: "Raleway-ExtraBold",
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, 'login_enter')!,
              style: const TextStyle(
                fontFamily: "Raleway-Regular",
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: getTranslated(context, 'mail'),
                  labelStyle: const TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
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
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).backgroundColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return getTranslated(context, 'error_mail_empty');
                  }
                  return null;
                }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                keyboardType: TextInputType.text,
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: getTranslated(context, 'password'),
                  labelStyle: const TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
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
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).backgroundColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return getTranslated(context, 'error_pw_empty');
                  }
                  return null;
                }),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(
                      fontFamily: "Raleway-Regular", fontSize: 14.0),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  padding: EdgeInsets.all(10.0),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Object? result = await _auth.signIn(
                        email: emailController.text,
                        password: passwordController.text);
                    if (result is GrimmUser) {
                      //print(result.toString());
                      /*print("Authentification OK = " +
                          result.uid +
                          " " +
                          result.name);*/
                      await Future.delayed(
                          const Duration(milliseconds: 200), () {});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          getTranslated(
                              context, 'snackbar_connection_success')!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFF1CB731),
                      ));
                      MenuScreen(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          getTranslated(context, 'snackbar_connection_error')!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFFB71C1C),
                      ));
                      //print(result.toString());
                    }
                  }
                },
                child: Text(getTranslated(context, 'button_connect')!)),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(
                    fontFamily: "Raleway-Regular", fontSize: 14.0),
                padding: EdgeInsets.all(10.0),
              ),
              child: Text(getTranslated(context, 'pw_forget')!),
              onPressed: () async {
                if (emailController.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(getTranslated(
                          context, 'snackbar_error_complet_email')!)));
                } else {
                  auth.sendPasswordResetEmail(email: emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          getTranslated(context, 'snackbar_email_send')! +
                              emailController.text)));
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: const TextStyle(
                                fontFamily: "Raleway-Regular", fontSize: 14.0),
                            padding: const EdgeInsets.all(20.0),
                          ),
                          onPressed: () async {
                            Language? newLanguage =
                                Language(2, 'Francais', 'fr');
                            _changeLanguage(newLanguage);
                          },
                          child: const Text("Français")),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: const TextStyle(
                                fontFamily: "Raleway-Regular", fontSize: 14.0),
                            padding: const EdgeInsets.all(20.0),
                          ),
                          onPressed: () async {
                            Language? newLanguage =
                                Language(1, 'English', 'en');
                            _changeLanguage(newLanguage);
                          },
                          child: const Text("English")),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: const TextStyle(
                                fontFamily: "Raleway-Regular", fontSize: 14.0),
                            padding: const EdgeInsets.all(20.0),
                          ),
                          onPressed: () async {
                            Language? newLanguage =
                                Language(3, 'Deutsch', 'de');
                            _changeLanguage(newLanguage);
                          },
                          child: const Text("Deutsch")),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
