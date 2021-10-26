import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimm_scanner/assets/constants.dart';

class GrimmItem {
  late final String id;

  /// Item description
  String description;

  /// Item location
  String location;

  /// Item category
  String idCategory;

  /// Item avaibality
  bool available;

  /// Item remark
  String remark;

  /// Default constructor
  /*GrimmItem(
      {this.description = "",
      this.location = "",
      this.idCategory = "",
      this.available = true,
      this.remark = ""});*/

  /// Default constructor
  GrimmItem({
    required this.id,
    required this.description,
    required this.location,
    required this.idCategory,
    required this.available,
    required this.remark,
  });

  /// Returns a readable GrimmItem object
  String toString() {
    return "GrimmItem{id:" +
        id +
        ",description:" +
        description +
        ",location:" +
        location +
        ",category:" +
        idCategory +
        ",remark:" +
        remark +
        ", available" +
        available.toString() +
        "}";
  }

  /// Translate a MyUser object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'description': description,
      'location': location,
      'idCategory': idCategory,
      'remark': remark,
      'available': available
    };
  }

  /// Retrieves the user info from Firebase document
  Future<void> populateItemInfoFromFirestore() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection("items").doc(id).get();
    if (snap.exists) {
      description = (snap.data()!["description"] != null
          ? snap.data()!["description"]
          : "");
      location =
          (snap.data()!["location"] != null ? snap.data()!["location"] : "");
      idCategory = (snap.data()!["idCategory"] != null
          ? snap.data()!["idCategory"]
          : "");
      remark = (snap.data()!["remark"] != null ? snap.data()!["remark"] : "");
      available = (snap.data()!["available"] != null
          ? snap.data()!["available"]
          : false);
      ;
    }
  }

  /// Set an user UID
  void setid(String id) {
    this.id = id;
  }

  /// Returns the String for QR code generation
  String getIdForQrCode() {
    print("GrimmItem - getIdForQrCode - " + Constants.grimmQrCodeStartsWith + this.id);
    return Constants.grimmQrCodeStartsWith + this.id;
  }
}
