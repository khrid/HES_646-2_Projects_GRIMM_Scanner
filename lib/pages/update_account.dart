import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController userNameController = new TextEditingController();
  TextEditingController userSurnameController = new TextEditingController();
  TextEditingController userEmailController = new TextEditingController();
  TextEditingController userPasswordController =
      new TextEditingController(); //TO DO Micaela
  TextEditingController userGroupController = new TextEditingController();
  var eventTypeSelectedValue;
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

    print(_user);

    _users = FirebaseFirestore.instance.collection("users");

    // TO DO Micaela
    Future<void> updateUser(GrimmUser u) async {
      //_users.doc(u.uid).update(u.toJson());
      u.updateFirestore();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Éditer utilisateur"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(50),
          children: <Widget>[
            Text(
              "Mofidier les informations de l'utilisateur",
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
              controller: userSurnameController,
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
              controller: userNameController,
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
            TextField(
              controller: userEmailController,
              decoration: InputDecoration(
                labelText: 'Email (non-modifiable actuellement)',
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
              cursorColor: Colors.black,
              enabled: false,
            ),
            SizedBox(
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
                  textStyle:
                      TextStyle(fontFamily: "Raleway-Regular", fontSize: 14.0),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  padding: EdgeInsets.all(20.0),
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
                  /*GrimmUser changedUser = GrimmUser(
                      name: userNameController.text,
                      firstname: userSurnameController.text,
                      email: _user!.email,
                      //TO DO checkbox Micaela
                      enable: _user!.enable,
                      groups: tab);
                  changedUser.setUid(_user!.uid);*/
                  _user!.name = userNameController.text;
                  _user!.firstname = userSurnameController.text;
                  _user!.groups = tab;

                  if (tab.isNotEmpty) {
                    if (_formKey.currentState!.validate()) {
                      updateUser(_user!);
                      print("Changements effectués");
                      //Navigator.pushNamed(context, UserDetail.routeName,
                      //    arguments: _user!.uid);
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Veuillez sélectionner un groupe au minimum.")));
                  }
                },
                child: Text("Valider les modifications")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle:
                      TextStyle(fontFamily: "Raleway-Regular", fontSize: 14.0),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  padding: EdgeInsets.all(20.0),
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
                      print("Désactivation effectuée");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Veuillez sélectionner un groupe au minimum.")));
                    }
                  }
                },
                child: Text(_user!.enable
                    ? "Désactiver le compte"
                    : "Activer le compte")),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
