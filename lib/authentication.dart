import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signIn(String e_mail, String passWord, bool isamb);

  Future<FirebaseUser> getCurrentUser();
  Future<String> signUp(String email, String password, String uname, bool isamb,
      GeoFirePoint point);

  sendEmail();

  Future<void> signOut();

  Future<void> sendResetMail(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore firestoreDb = Firestore.instance;
  var outlet;
  var ssaID;

  Future<String> signIn(String e_mail, String passWord, bool isamb) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: e_mail, password: passWord);
    FirebaseUser user = result.user;
    print(result.user.uid);
    print(user.email);
    int usrflag = 0;
    int mflag = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uname;

    if (isamb == false) {
      await firestoreDb.collection('users').document(e_mail).get().then((doc) {
        if (doc.exists) {
          uname = doc.data['uname'];
          print("this is a user");
        } else {
          print("you are not a user");
          usrflag = 1;
        }
      }).catchError((onError) {
        print(onError);
      });
    } else {
      await firestoreDb
          .collection('medical')
          .document(e_mail)
          .get()
          .then((doc) {
        if (doc.exists) {
          uname = doc.data['uname'];

          print("this is a medical officer");
        } else {
          print("you are not a medical officer");
          mflag = 1;
        }
      }).catchError((onError) {
        print(onError);
      });
    }

    if (isamb == false && usrflag == 1) {
      return null;
    } else if (isamb == false && usrflag == 0) {
      prefs.setBool('user', true);
      prefs.setString('email', user.email);
      prefs.setString('uname', uname);
      return user.uid;
    } else if (isamb == true && mflag == 1) {
      return null;
    } else if (isamb == true && mflag == 0) {
      prefs.setBool('user', false);
      prefs.setString('email', user.email);
      prefs.setString('uname', uname);
      return user.uid;
    }

    // return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  sendEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print(user.email);
    return user.email;
  }

  Future<String> signUp(String email, String password, String uname, bool isamb,
      GeoFirePoint point) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    if (isamb == false) {
      firestoreDb.collection('users').document(email).setData({
        'email': email,
        'uname': uname,
        'position': point.data,
        'online': true,
        'visits': 0
      }).then((val) {
        print("Account created successfully");
      }).catchError((onError) {
        print(onError.toString());
      });
    } else {
      firestoreDb.collection('medical').document(email).setData({
        'email': email,
        'uname': uname,
        'position': point.data,
        'online': true,
        'visits': 0
      }).then((val) {
        print("Account created successfully");
      }).catchError((onError) {
        print(onError);
      });
    }

    return user.uid;
  }

  // getEmail() async {
  //   FirebaseUser user = await _firebaseAuth.currentUser();
  //   return user.email;
  // }
  sendResetMail(email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
