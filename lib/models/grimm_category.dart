import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimm_scanner/models/grimm_item.dart';

class GrimmCategory {
  late final String id;

  /// User name
  String name;

  /// Default constructor
  GrimmCategory({
    this.id = "",
    required this.name,
  });

  /// Returns a readable Category object
  String toString() {
    return "GrimmCategory{id:" +
        id +
        ",name:" +
        name +
        "}";
  }

  /// Translate a Category object to JSON
  GrimmCategory.fromJson(json)
      : this(
    id: json.id,
    name: (json.data()!['name'] ?? ""),
  );

  /// Translate a Category object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'name': name,
    };
  }

  /// Retrieves the Category info from Firebase document
  Future<void> populateUserInfoFromFirestore() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
    await FirebaseFirestore.instance.collection("category").doc(id).get();
    if (snap.exists) {
      name =
      (snap.data()!["name"] != null ? snap.data()!["name"] : "");
    }
  }


  Future<void> updateFirestore() async {
    print(this);
    await FirebaseFirestore.instance.collection("category").doc(id).set(toJson());
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("category").add(toJson());
  }

  Future<void> updateItemsDeletedCategory() async {
    QuerySnapshot snap =
    await FirebaseFirestore.instance.collection("items").where('idCategory', isEqualTo: id).get();
    if (snap.docs.isNotEmpty) {
      if(snap.docs.length > 1) {
      } else {
        snap.docs.forEach((element) {
          GrimmItem grimmItem = GrimmItem.fromJson(element);
          grimmItem.idCategory = 'Qh3F15Werg9qeNToe7fT';
          grimmItem.updateFirestore();
        });
      }
    }
  }
}