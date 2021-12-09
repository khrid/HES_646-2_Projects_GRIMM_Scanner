import 'package:firebase_auth/firebase_auth.dart';
import '../models/grimm_user.dart';
import 'dart:developer' as developer;

/// Manage the authentication with Firebase
class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService();

  /// create user object base on FirebaseUser
  GrimmUser? _userFromFirebaseUser(User user) {
    if (user == null) return null;
    GrimmUser grimmUser = GrimmUser(groups: []);
    grimmUser.setEmail(_auth.currentUser!.email.toString());
    grimmUser.setUid(user.uid);
    grimmUser.populateUserInfoFromFirestore();
    return grimmUser;
  }

  /// complete the user object with info from the "users" collection
  Future _populateUserInfoFromCollection(User user) async {
    return null;
  }

  /// sync the user status with firebase
  Stream<GrimmUser?> get user {
    return _auth.authStateChanges().map((User? user) {
      return _userFromFirebaseUser(user!);
    });
  }

  /// Tries to sign in with email and password, and returns a MyUser if successful
  Future signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      developer.log(
          "AuthenticationService - signIn - returned user uid = " + user!.uid);
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      developer.log(
          "AuthenticationService - signIn - FireBaseAuthException message = " +
              e.message.toString());
      return e.message;
    }
  }

  /// Sign out from the current account
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  /// Allows to sign up with given credentials, creates the account in Firebase
  Future signUp(
      {required String email,
      required String password,
      required GrimmUser grimmUser}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      grimmUser.setUid(result.user!.uid);
      await grimmUser.saveToFirestore();
      return grimmUser;
    } on FirebaseAuthException {}
  }
}
