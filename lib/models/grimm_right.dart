import 'package:cloud_firestore/cloud_firestore.dart';



class GrimmRight {
  late final String id;
  String description = "";
  late List permissions = [];

  GrimmRight(
      {this.id = "",
      required this.description,
      required this.permissions,});


  GrimmRight.fromJson(json)
      : this(
    id: json.id,
    description: (json.data()!['description']),
    permissions: (json.data()!['permissions']),
  );


  @override
  String toString() {
    return "GrimmRight{id:" +
        id +
        ",description:" +
        description +
        ",permissions:" +
        permissions.toString() ;
  }

  /// Translate a GrimmHistory object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'description': description,
      'permissions': permissions
    };
  }

  Future<void> save() async {
    DocumentReference ref = await FirebaseFirestore.instance.collection("rights").add(toJson());
  }

  Future<void> update() async {
    await FirebaseFirestore.instance.collection("rights").doc(id).set(toJson());
  }


}
