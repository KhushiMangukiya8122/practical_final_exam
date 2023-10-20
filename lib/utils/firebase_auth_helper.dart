import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebasestore_helper.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  String? email;
  String? password;

// todo: signUpWithEmailandpassword

  Future<Map<String, dynamic>> signupWithEmailPassword(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
      };

      await FireStoreHelper.fireStoreHelper
          .insertUserWhileSignIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporary down";
        case "weak-password":
          data["msg"] = "Password must be grater than 6 char.";
        case "email-already-in-use":
          data["msg"] = "User with this email id is already exists";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

//todo: signinwithEmailandPassword
  Future<Map<String, dynamic>> signinWithEmailPassword(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporary down";
        case "wrong-password":
          data["msg"] = "Password is wrong";
        case "user-not-found":
          data["msg"] = "User does not exists with this email id";
        case "user-disabled":
          data["msg"] = "User is disabled ,contact admin";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

//todo: signInWithGoogle

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> data = {};

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
      };

      await FireStoreHelper.fireStoreHelper
          .insertUserWhileSignIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporary down";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

//todo: signout

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
