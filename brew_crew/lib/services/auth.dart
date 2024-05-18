import 'dart:async';
import 'package:brew_crew/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class AuthService {

  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User? _userFromFirebaseUser(FirebaseAuth.User? user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map((FirebaseAuth.User? user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      FirebaseAuth.UserCredential userCredential = await _auth.signInAnonymously();
      FirebaseAuth.User? user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password

  // register with email and password

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}