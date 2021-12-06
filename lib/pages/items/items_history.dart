import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grimm_scanner/localization/language_constants.dart';
import 'package:grimm_scanner/models/grimm_history.dart';
import 'package:grimm_scanner/models/grimm_item.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:grimm_scanner/widgets/card_history.dart';
import 'package:intl/intl.dart';

class ItemHistory extends StatefulWidget {
  static const routeName = "/items/item/history";

  const ItemHistory({Key? key}) : super(key: key);

  @override
  _ItemHistoryState createState() => _ItemHistoryState();
}

class _ItemHistoryState extends State<ItemHistory> {
  @override
  Widget build(BuildContext context) {
    final grimmItem = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as GrimmItem;

    if (grimmItem == "NULL") {
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'appbar_history')!),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
            child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("history")
                  .orderBy("dateBorrow", descending: true)
                  .where("itemRef", isEqualTo: (grimmItem as GrimmItem).id)
                  .snapshots(),
              builder: buildHistory),
        )));
  }

  Widget buildHistory(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Column(children: <Widget>[
        ListView(
          physics: const ClampingScrollPhysics(), // add t
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            GrimmHistory grimmHistory = GrimmHistory.fromJson2(doc);
            final DateFormat formatter = DateFormat('dd.MM.yyyy H:m');

            Widget borrowText = StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(grimmHistory.userBorrow)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.hasData) {
                  GrimmUser grimmUserBorrow = GrimmUser.fromJson(snapshot.data);
                  return Text(
                      formatter.format(grimmHistory.dateBorrow!.toDate()) +
                          "\n" +
                          grimmUserBorrow.firstname +
                          " " +
                          grimmUserBorrow.name,
                      textAlign: TextAlign.center);
                }
                return const Text("");
              },
            );

            var returnText;
            if (grimmHistory.dateReturn != null) {
              returnText = StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(grimmHistory.userReturn)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    GrimmUser grimmUserReturn =
                        GrimmUser.fromJson(snapshot.data);
                    return Text(
                        formatter.format(grimmHistory.dateReturn!.toDate()) +
                            "\n" +
                            grimmUserReturn.firstname +
                            " " +
                            grimmUserReturn.name,
                        textAlign: TextAlign.center);
                  }
                  return const Text("");
                },
              );
            } else {
              returnText = Text(getTranslated(context, 'error_empty')!);
            }

            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CardHistory(
                  borrowText: borrowText,
                  returnText: returnText,
                ));
          }).toList(),
        )
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
