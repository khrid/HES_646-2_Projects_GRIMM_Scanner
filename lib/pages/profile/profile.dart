import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
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
          title: Text(getTranslated(context, 'appbar_admin_profil')!),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Form(
            key: _formKey,
            child:
                ListView(padding: const EdgeInsets.all(50), children: <Widget>[
              Text(
                getTranslated(context, 'title_modify_profil')!,
                style: const TextStyle(
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
                    return getTranslated(context, 'error_firstname_empty')!;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: getTranslated(context, 'firstname_simple')!,
                  labelStyle: const TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: userNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return getTranslated(context, 'error_lastname_empty')!;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: getTranslated(context, 'name_simple')!,
                  labelStyle: const TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: userEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: getTranslated(context, 'email_simple')!,
                  labelStyle: const TextStyle(
                    fontFamily: "Raleway-Regular",
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(userEmailController.text);
                    if (_formKey.currentState!.validate()) {
                      if (emailValid == true) {
                        user.email = userEmailController.text;
                        _changeMail(userEmailController.text);
                        updateUser(user);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            getTranslated(context, 'snackbar_update_success')!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          duration: const Duration(seconds: 5),
                          backgroundColor: const Color(0xFF1CB731),
                        ));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            getTranslated(context, 'snackbar_error_mail')!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          duration: const Duration(seconds: 5),
                          backgroundColor: const Color(0xFFB71C1C),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          getTranslated(context, 'snack_error_profile')!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFFB71C1C),
                      ));
                    }
                  },
                  child:
                      Text(getTranslated(context, 'button_validate_modif')!)),
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
