import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
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
        title: const Text("Gestion des droits"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rights')
                    .doc(rightUID)
                    .snapshots(),
                builder: buildRightsDetail,
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
}



Widget buildRightsDetail(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    print(snapshot.data);
    var tab = [];
    

    if (snapshot.hasData) {
      if (snapshot.data!.data() != null) {
        right = GrimmRight.fromJson(snapshot.data);
        print("salut");
        print(right.toString());
        if (firstLoad == 1) {
     // _right = ModalRoute.of(context)!.settings.arguments as GrimmRight;

          if (right.permissions.contains("Administrator")) isAdmin = true;
          if (right.permissions.contains("Member")) isMember = true;
          if (right.permissions.contains("ObjectManager")) isObjectManager = true;
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
                        padding: EdgeInsets.all(50),
                        children: <Widget>[
                          Text("Permission : "+right.description,
                          style: TextStyle(
                          fontFamily: "Raleway-Regular", fontSize: 25.0),
                          ),
                          const SizedBox(
                            height: 40,
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
                                right!.permissions = tab;

                                if (tab.isNotEmpty) {
                                  if (_formKey.currentState!.validate()) {
                                    updateRight(right!);
                                    print("Changements effectués");
                                    Navigator.pop(context);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text(
                                          "Veuillez sélectionner un rôle au minimum.")));
                                }
                              },
                              child: Text("Valider les modifications")),
                              const SizedBox(
                          height: 20,
                        ),
                      ]
                      )
                      )
                      ]
                ));
                    } else {
                      return Text("Erreur1");
                    }
                  }
                  return Text("Erreur2");
                }

}

