// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
//
// class LoginAuthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//
//   GoogleSignInAccount? _user;
//
//   GoogleSignInAccount get user => _user!;
//
//   bool isSignIn = false;
//   bool isGoogle = false;
//
//   Future<UserCredential> signInWithGoogle() async {
//     var idToken;
//     String? name;
//     String? email;
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     idToken = _auth.currentUser?.getIdToken(true);
//
//     _user = googleUser;
//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth =
//     await googleUser?.authentication;
//
//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//
//     );
//     var uid = FirebaseAuth.instance.currentUser?.uid;
//     // Once signed in, return the UserCredential
//     isGoogle = true;
//     notifyListeners();
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//
//     notifyListeners();
//   }
//
//   Future<UserCredential> signInWithGoogle_T() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth = await googleUser
//         ?.authentication;
//
//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//
//     print("current user : ${FirebaseAuth.instance.currentUser?.uid}");
//     print("${_googleSignIn.currentUser?.id}");
//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//
//   Future signOut() async {
//     if (FirebaseAuth.instance.currentUser?.isAnonymous == true) {
//       try {
//         await FirebaseAuth.instance.signOut();
//       } on FirebaseException catch (e) {
//         switch (e.code) {
//           case "operation-not-allowed":
//             print("Anonymous auth hasn't been enabled for this project.");
//             break;
//           default:
//             print("Unknown error.");
//         }
//       }
//     } else {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//       this.isGoogle = false;
//     }
//   }
// }