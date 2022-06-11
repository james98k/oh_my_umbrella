
import 'dart:async';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'geoLocation.dart';


FirebaseFirestore db = FirebaseFirestore.instance;

class ApplicationState extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore? db = FirebaseFirestore.instance;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in1!');
      }
    });

    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in2!');
      }
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in3!');
      }
    });
  }

  Future<void> UploadNewItemData() async {
    final docItem = FirebaseFirestore.instance.collection('item').doc('my-id');
  }

  @override
  notifyListeners();
}


class LoginAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  String uid = "";

  bool isSignIn = false;
  bool isGoogle = false;



  Future<UserCredential> signInWithGoogle() async {
    Future<String>? idToken;
    String? name;
    String? email;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    print("${googleUser?.displayName}");


    idToken = _auth.currentUser?.getIdToken(true);
    print("${idToken}<========id token ");
    this.uid = idToken.toString();
    _user = googleUser;
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,

    );
    var uid = FirebaseAuth.instance.currentUser?.uid;
    // Once signed in, return the UserCredential
    //
    isGoogle = true;
    // handleUserExists();
    notifyListeners();
    return await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }
  void handleUserExists(){

    String? uid = _auth.currentUser?.uid;
    String? email = _auth.currentUser?.email;
    String? name = _auth.currentUser?.displayName;
    print(_auth.currentUser?.uid);

    print("uid : $uid");
    Future addUserToDb() async {
      db.collection("user")
          .doc(uid).set(<String, dynamic>{
        'email' : email,
        'name' : name,
        'uid' : uid,
      })
          .whenComplete(() => print("user added to db"));
    }

    bool userExists = false;
    final docRef = db.collection("user").doc(uid);
    docRef.get()
        .then((res) => {
      userExists = res.exists
    });

    userExists ? print("user exist") : addUserToDb();
  }

  Future<UserCredential> signInWithGoogle_T() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print("current user : ${FirebaseAuth.instance.currentUser?.uid}");
    print("${_googleSignIn.currentUser?.id}");
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signOut() async {
    if (FirebaseAuth.instance.currentUser?.isAnonymous == true) {
      try {
        await FirebaseAuth.instance.signOut();
      } on FirebaseException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            print("Anonymous auth hasn't been enabled for this project.");
            break;
          default:
            print("Unknown error.");
        }
      }
    } else {
      await _googleSignIn.signOut();
      await _auth.signOut();
      isGoogle= false;
      print("user is logged out");
    }
  }

  @override
  notifyListeners();
}
