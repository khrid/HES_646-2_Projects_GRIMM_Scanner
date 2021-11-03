import 'package:cloud_firestore/cloud_firestore.dart';

class GrimmHistory {
  late final String id;

  String itemRef;

  Timestamp? dateBorrow;

  Timestamp? dateReturn;

  String userBorrow;

  String userReturn;

  GrimmHistory(
      {this.id = "",
      required this.itemRef,
      required this.dateBorrow,
      this.dateReturn,
      required this.userBorrow,
      this.userReturn = ""});



  GrimmHistory.fromJson(json)
      : this(
    id: json.id,
    itemRef: (json.data()!['itemRef'] ?? ""),
    dateBorrow: (json.data()!['dateBorrow']),
    dateReturn: (json.data()!['dateReturn']),
    userBorrow: (json.data()!['userBorrow'] ?? "null"),
    userReturn: (json.data()!['userReturn'] ?? "null"),
  );

  @override
  String toString() {
    return "GrimmHistory{id:" +
        id +
        ",itemRef:" +
        itemRef +
        ",dateBorrow:" +
        dateBorrow.toString() +
        ",dateReturn:" +
        dateReturn.toString() +
        ",userBorrow:" +
        userBorrow +
        ", userReturn:" +
        userReturn +
        "}";
  }

  /// Translate a GrimmHistory object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'itemRef': itemRef,
      'dateBorrow': dateBorrow,
      'dateReturn': dateReturn,
      'userBorrow': userBorrow,
      'userReturn': userReturn
    };
  }

  Future<void> save() async {
    await FirebaseFirestore.instance.collection("history").add(toJson());
  }

  Future<void> update() async {
    await FirebaseFirestore.instance.collection("history").doc(id).set(toJson());
  }

}
