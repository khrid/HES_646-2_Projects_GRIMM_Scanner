import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimm_scanner/assets/constants.dart';
import 'package:grimm_scanner/models/grimm_history.dart';

class GrimmItem {
  late final String id;

  /// Item description
  String description;

  /// Item location
  String location;

  /// Iteam color
  String color;

  /// Item category
  String idCategory;

  /// Item avaibality
  bool available;

  /// Item remark
  String remark;

  Map<dynamic, dynamic>? customFields = <dynamic, dynamic>{};

  /// Default constructor
  GrimmItem(
      {this.id = "",
      required this.description,
      required this.location,
      required this.color,
      required this.idCategory,
      required this.available,
      required this.remark,
      customFields});

  /// Returns a readable GrimmItem object
  @override
  String toString() {
    return "GrimmItem{id:" +
        id +
        ",description:" +
        description +
        ",location:" +
        location +
        ", color:" +
        color +
        ",category:" +
        idCategory +
        ",remark:" +
        remark +
        ", available:" +
        available.toString() +
        ", customFields:" +
        customFields.toString() +
        "}";
  }

  GrimmItem.fromJson(json)
      : this(
          id: json.id,
          description: (json.data()!['description'] ?? "-"),
          location: (json.data()!['location'] ?? "-"),
          color: (json.data()!['color'] ?? "-"),
          idCategory: (json.data()!['idCategory'] ?? "").toString().trim(),
          remark: (json.data()!['remark'] ?? "-"),
          available: (json.data()!['available'] ?? false),
          customFields: (json.data()!['customFields'] ?? []),
        );

  /// Translate a MyUser object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'description': description,
      'location': location,
      'color': color,
      'idCategory': idCategory,
      'remark': remark,
      'available': available,
      'customFields': customFields
    };
  }

  Future<void> updateFirestore() async {
    await FirebaseFirestore.instance.collection("items").doc(id).set(toJson());
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("items").add(toJson());
  }

  /// Retrieves the user info from Firebase document
  Future<void> populateItemInfoFromFirestore() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection("items").doc(id).get();
    if (snap.exists) {
      description = (snap.data()!["description"] ?? "");
      location = (snap.data()!["location"] ?? "-");
      color = (snap.data()!["color"] ?? "-");
      idCategory = (snap.data()!["idCategory"] ?? "");
      remark = (snap.data()!["remark"] ?? "-");
      available = (snap.data()!["available"] ?? false);
      customFields = Map.of(snap.data()!["customFields"]);
    }
  }

  /// Set an user UID
  void setid(String id) {
    this.id = id;
  }

  /// Returns the String for QR code generation
  String getIdForQrCode() {
    //print("GrimmItem - getIdForQrCode - " + Constants.grimmQrCodeStartsWith + id);
    return Constants.grimmQrCodeStartsWith + id;
  }

  String getDescriptionForPdfFilename() {
    String tmp = description
        .toLowerCase()
        .replaceAll(" ", "_")
        .replaceAll("[:\\\\/*?|<>]", "_");
    //print(tmp);
    return tmp;
  }

  void addCustomField(dynamic key, dynamic value) {
    customFields ??= <dynamic, dynamic>{};
    customFields!.putIfAbsent(key, () => value);
  }

  /// Update the availability of the object
  void updateAvailability(String uid) {
    available = !available;
    updateFirestore();
    saveMovement(uid);
  }

  Future<void> saveMovement(String uid) async {
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
      if (existingHistory.docs.length > 1) {
        // qqch de pas normal si on a plus d'un enregistrement sans date de retour
      } else {
        existingHistory.docs.forEach((element) {
          GrimmHistory grimmHistory = GrimmHistory.fromJson(element);
          grimmHistory.dateReturn = Timestamp.now();
          grimmHistory.userReturn = uid;
          grimmHistory.update();
        });
      }
    } else {
      GrimmHistory(itemRef: id, dateBorrow: Timestamp.now(), userBorrow: uid)
          .save();
    }
  }
}
