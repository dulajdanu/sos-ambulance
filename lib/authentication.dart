import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signIn(String e_mail, String passWord, bool isamb);

  Future<FirebaseUser> getCurrentUser();
  Future<String> signUp(
      String email, String password, String uname, bool isamb);

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
    print("ssss");
    int usrflag = 0;
    int mflag = 0;

    if (isamb == false) {
      await firestoreDb.collection('users').document(e_mail).get().then((doc) {
        if (doc.exists) {
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
          print("this is a medical officer");
        } else {
          print("you are not a medical officer");
          mflag = 1;
        }
      }).catchError((onError) {
        print(onError);
      });
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('email', user.email);
    // print("printing e mail of user " + user.email);

    // firestoreDb.collection('users').document(user.email).get().then((docval) {
    //   print(docval.data);
    //   if (docval.exists) {
    //     // outlet = docval["outlet"];
    //     ssaID = docval["ID"];
    //     print(ssaID);
    //     outlet = docval["outlet"];

    //     prefs.setString("outlet", outlet);

    //     prefs.setString('ID', ssaID);
    //     prefs.setString('uid', user.uid);
    //     prefs.setString("AuthID", result.user.uid);

    //     print(prefs.getString('ID'));
    //     prefs.setString('usrMail', user.email);
    //     prefs.setString('picUrl',
    //         'https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg');
    //   } else {
    //     print("no document of the user");
    //     return;
    //   }

    //   // outlet = docval["outlet"];
    //   // print(outlet);
    // }).catchError((onError) => print(onError));
    if (isamb == false && usrflag == 1) {
      return null;
    } else if (isamb == false && usrflag == 0) {
      return user.uid;
    } else if (isamb == true && mflag == 1) {
      return null;
    } else if (isamb == true && mflag == 0) {
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

  Future<String> signUp(
      String email, String password, String uname, bool isamb) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    if (isamb == false) {
      firestoreDb
          .collection('users')
          .document(email)
          .setData({'email': email, 'uname': uname})
          .then((val) => {print("Account created successfully")})
          .catchError((onError) => {print(onError)});
    } else {
      firestoreDb
          .collection('medical')
          .document(email)
          .setData({'email': email, 'uname': uname})
          .then((val) => {print("Account created successfully")})
          .catchError((onError) => {print(onError)});
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
