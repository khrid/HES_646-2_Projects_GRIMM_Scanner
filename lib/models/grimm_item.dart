import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_history.dart';

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
  @override
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

  GrimmItem.fromJson(json)
      : this(
          id: json.id,
          description: (json.data()!['description'] ?? ""),
          location: (json.data()!['location'] ?? ""),
          idCategory: (json.data()!['idCategory'] ?? ""),
          remark: (json.data()!['remark'] ?? ""),
          available: (json.data()!['available'] ?? false),
        );

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

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("items").doc(id).set(toJson());
  }

  /// Retrieves the user info from Firebase document
  Future<void> populateItemInfoFromFirestore() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection("items").doc(id).get();
    if (snap.exists) {
      description = (snap.data()!["description"] ?? "");
      location = (snap.data()!["location"] ?? "");
      idCategory = (snap.data()!["idCategory"] ?? "");
      remark = (snap.data()!["remark"] ?? "");
      available = (snap.data()!["available"] ?? false);
    }
  }

  /// Set an user UID
  void setid(String id) {
    this.id = id;
  }

  /// Returns the String for QR code generation
  String getIdForQrCode() {
    print("GrimmItem - getIdForQrCode - " +
        Constants.grimmQrCodeStartsWith +
        id);
    return Constants.grimmQrCodeStartsWith + id;
  }

  String getDescriptionForPdfFilename() {
    String tmp = description.toLowerCase().replaceAll(" ", "_").replaceAll("[:\\\\/*?|<>]", "_");
    print(tmp);
    return tmp;
  }

  /// Update the availability of the object
  void updateAvailability() {
    available = !available;
    saveToFirestore();
    saveMovement();
  }

  Future<void> saveMovement() async {
    // trois cas possibles
    // 1 > pas de record dispo
    // 2 > record dispo, date de retour vide
    // 3 > record dispo, date de retour non vide

    // on va chercher si un mouvement existe pour cet objet
    QuerySnapshot existingHistory = await FirebaseFirestore.instance
        .collection("history")
        .where("itemRef", isEqualTo: id)
        .where("dateReturn", isNull: true)
        .get();

    if (existingHistory.docs.isNotEmpty) {
      if(existingHistory.docs.length > 1) {
        // qqch de pas normal si on a plus d'un enregistrement sans date de retour
      } else {
        existingHistory.docs.forEach((element) {
          GrimmHistory grimmHistory = GrimmHistory.fromJson(element);
          grimmHistory.dateReturn = Timestamp.now();
          grimmHistory.userReturn = "QlkuFCmJjIUd1akCuWOGxfVXNCG2";
          grimmHistory.update();
        });
      }
    } else {
      GrimmHistory(
              itemRef: id,
              dateBorrow: Timestamp.now(),
              userBorrow: "QlkuFCmJjIUd1akCuWOGxfVXNCG2")
          .save();
    }
    /**/
  }
}
