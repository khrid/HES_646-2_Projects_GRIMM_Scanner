import 'package:cloud_firestore/cloud_firestore.dart';

class GrimmUser {
  late final String uid;
  /// User firstname
  String firstname;
  /// User lastname
  String name;
  /// User email
  String email;
  /// Event that the user is attending to
  late List groups = [];
  /// Default constructor
  GrimmUser(
      {this.firstname = "",
      this.name = "",
      this.email = "",
      required this.groups});

  /// Returns a readable MyUser object
  String toString() {
    return "GrimmUser{uid:" +
        uid +
        ",firstname:" +
        firstname +
        ",name:" +
        name +
        ",email:" +
        email +
        ",groups:" +
        groups.toString() +
        "}";
  }
  /// Translate a MyUser object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'firstname': firstname,
      'name': name,
      'email': email,
      'groups': groups,
    };
  }
  /// Retrieves the user info from Firebase document
  Future<void> populateUserInfoFromFirestore() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (snap.exists) {
      name =
          (snap.data()!["name"] != null ? snap.data()!["name"] : "");
      firstname =
          (snap.data()!["firstname"] != null ? snap.data()!["firstname"] : "");
      email = (snap.data()!["email"] != null ? snap.data()!["email"] : "");
      groups = (snap.data()!['groups'] != null
          ? List.from(snap.data()!['groups'].toSet())
          : []);
    }
  }
  /// Save the user info to Firebase
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set(toJson());
  }
  /// Remove the group from the user groups list and sync it with Firebase
  removeGroup(String groupId) async {
    groups.remove(groupId);
    saveToFirestore();
  }
  /// Add the group from the users group list and sync it with Firebase
  addGroup(String groupId) async {
    groups.add(groupId);
    //await FirebaseFirestore.instance.collection("users").doc(uid).update(toJson());
    saveToFirestore();
  }
  /// Set an user UID
  void setUid(String uid) {
    this.uid = uid;
  }


  void setEmail(String email) {
    this.email = email;
  }
}

