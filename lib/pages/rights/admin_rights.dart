import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_item.dart';


class RightsAdmin extends StatefulWidget {
  static const routeName = "/admin/rightsadmin";

  const RightsAdmin({Key? key}) : super(key: key);

  @override
  _RightsAdminState createState() => _RightsAdminState();
}

class _RightsAdminState extends State<RightsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion des droits"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
       body: Center(
            child: SingleChildScrollView(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
        
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text("yo")
                      ],
                                  ),
                                ],
                              )))
                          //drawer: const CustomDrawer(),
                          );
                    }
}
