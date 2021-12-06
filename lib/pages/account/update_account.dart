import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_user.dart';

class UserUpdate extends StatefulWidget {
  static const routeName = "/users/detail/update";

  const UserUpdate({Key? key}) : super(key: key);

  @override
  _UserUpdateState createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  final _formKey = GlobalKey<FormState>();

  GrimmUser? _user;
  late CollectionReference _users;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userSurnameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userGroupController = TextEditingController();
  int firstLoad = 1;

  bool isAdmin = false;
  bool isObjectManager = false;
  bool isMember = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tab = [];
    if (firstLoad == 1) {
      _user = ModalRoute.of(context)!.settings.arguments as GrimmUser;
      if (_user!.groups.contains("Administrator")) isAdmin = true;
      if (_user!.groups.contains("Member")) isMember = true;
      if (_user!.groups.contains("ObjectManager")) isObjectManager = true;
      userNameController.text = _user!.name;
      userSurnameController.text = _user!.firstname;
      userEmailController.text = _user!.email;
      firstLoad = 0;
    }
    _users = FirebaseFirestore.instance.collection("users");

    Future<void> updateUser(GrimmUser u) async {
      u.updateFirestore();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_user_update')!),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(50),
          children: <Widget>[
            Text(
              getTranslated(context, 'title_update_account')!,
              style: const TextStyle(
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
              height: 20,
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
              height: 20,
            ),
            TextField(
              controller: userEmailController,
              decoration: InputDecoration(
                labelText: getTranslated(context, 'email_no_change')!,
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
              cursorColor: Colors.black,
              enabled: false,
            ),
            const SizedBox(
              height: 20,
            ),
            CheckboxListTile(
              title: Text(getTranslated(context, 'administrator')!),
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
              title: Text(getTranslated(context, 'objectManager')!),
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
              title: Text(getTranslated(context, 'membre')!),
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
                  if (isAdmin) {
                    tab.add("Administrator");
                  }
                  if (isMember) {
                    tab.add("Member");
                  }
                  if (isObjectManager) {
                    tab.add("ObjectManager");
                  }
                  _user!.name = userNameController.text;
                  _user!.firstname = userSurnameController.text;
                  _user!.groups = tab;

                  if (tab.isNotEmpty) {
                    if (_formKey.currentState!.validate()) {
                      updateUser(_user!);
                      //("Changements effectués");
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getTranslated(
                            context, 'snackbar_error_one_group_min')!)));
                  }
                },
                child: Text(getTranslated(context, 'button_validate')!)),
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
                  if (_formKey.currentState!.validate()) {
                    if (isAdmin) {
                      tab.add("Administrator");
                    }
                    if (isMember) {
                      tab.add("Member");
                    }
                    if (isObjectManager) {
                      tab.add("ObjectManager");
                    }
                    if (tab.isNotEmpty) {
                      _user!.updateStatus();
                      Navigator.pop(context);
                      //print("Désactivation effectuée");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(getTranslated(
                              context, 'snackbar_error_one_group_min')!)));
                    }
                  }
                },
                child: Text(_user!.enable
                    ? getTranslated(context, 'desactivitation')!
                    : getTranslated(context, 'activation')!)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
