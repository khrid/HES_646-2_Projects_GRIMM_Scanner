import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_right.dart';

class RightsAdminDetail extends StatefulWidget {
  static const routeName = "/admin/rightsadmin/detail";

  const RightsAdminDetail({Key? key}) : super(key: key);

  @override
  _RightsAdminDetailState createState() => _RightsAdminDetailState();
}

class _RightsAdminDetailState extends State<RightsAdminDetail> {
  late GrimmRight right;
  final _formKey = GlobalKey<FormState>();
  bool isAdmin = false;
  bool isObjectManager = false;
  bool isMember = false;
  int firstLoad = 1;

  @override
  Widget build(BuildContext context) {
    var rightUID;
    rightUID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'appbar_rights_admin')!),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc(rightUID)
                    .snapshots(),
                builder: buildRightsDetail,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRightsDetail(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    var tab = [];
    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);
        if (firstLoad == 1) {
          if (right.permissions.contains("Administrator")) isAdmin = true;
          if (right.permissions.contains("Member")) isMember = true;
          if (right.permissions.contains("ObjectManager")) {
            isObjectManager = true;
          }
          firstLoad = 0;
        }

        Future<void> updateRight(GrimmRight grimmRight) async {
          grimmRight.update();
        }

        return Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Form(
              key: _formKey,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    Text(
                      '"' + right.description + '"',
                      style: const TextStyle(
                          fontFamily: "Raleway-Regular", fontSize: 25.0),
                    ),
                    const SizedBox(
                      height: 40,
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
                          side:
                              const BorderSide(width: 1.0, color: Colors.black),
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
                          right.permissions = tab;

                          if (tab.isNotEmpty) {
                            if (_formKey.currentState!.validate()) {
                              updateRight(right);
                              Navigator.pop(context);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                getTranslated(
                                    context, 'snackbar_choose_only_one_role')!,
                              ),
                              duration: const Duration(seconds: 3),
                              backgroundColor: const Color(0xFFB71C1C),
                            ));
                          }
                        },
                        child: Text(
                            getTranslated(context, 'button_validate_modif')!)),
                    const SizedBox(
                      height: 20,
                    ),
                  ]))
        ]));
      } else {
        return Text(getTranslated(context, 'error_simple')!);
      }
    }
    return Text(getTranslated(context, 'error_simple')!);
  }
}
