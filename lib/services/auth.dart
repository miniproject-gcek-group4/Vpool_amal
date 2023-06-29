import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:untitled1/services/databaseService.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

///class hold all the authentication services
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NewUser? _userFromFirebaseUser(User? user) {
    return user != null
        ? NewUser(uid: user.uid, username: user.email ?? "")
        : null;
  }

  Stream<NewUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  ///////
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Password reset email sent',
        ),
      );
    } catch (e) {
      showTopSnackBar(Overlay.of(context),
          const CustomSnackBar.error(message: "Invalid email"));
      throw Exception(e.toString());
    }
  }

  //////

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      //UserCredential====AuthResult,User====FirebaseUser,onAuthSTateChanges====authStateChanges
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailandPasswordtraveller(String email, String password,
      String username, String phno, String adhar) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await UserDatabaseService()
          .updateTravellerData(email, username, phno, adhar);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailandPasswordowner(
      String email,
      String password,
      String username,
      String phno,
      String adhar,
      String licence,
      String rcbook,
      String vno) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await UserDatabaseService()
          .updateOwnerData(email, username, phno, adhar, vno, rcbook, licence);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailandPassworddual(
      String email,
      String password,
      String username,
      String phno,
      String adhar,
      String licence,
      String rcbook,
      String vno) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await UserDatabaseService()
          .updateDualData(email, username, phno, adhar, vno, rcbook, licence);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
