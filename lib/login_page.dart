// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oh_my_umbrella/main.dart';
import 'API/Firebase.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _NewLoginState createState() => _NewLoginState();
}

class _NewLoginState extends State<LoginPage> {
  // const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  SizedBox(width: 300, height: 300),

                  // LoginWidget(),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: AspectRatio(
                            aspectRatio: 18.0 / 18.0,
                            child: Image.asset('assets/images/umbrella_black.png'),
                          ),
                        ),
                        SizedBox(height : 20),
                        Text("Oh My Umbrella!", style : TextStyle(fontSize: 30)),
                        SizedBox(height : 20),

                        // Center(
                        //   child: ,
                        // ),
                        Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: ElevatedButton.icon(
                                  label: const Text('Google'),
                                  icon: const Icon(Icons.question_mark),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                  ),
                                  onPressed: () => LoginAuthProvider()
                                      .signInWithGoogle()
                                      .then((value) => (LoginAuthProvider()
                                          .handleUserExists()))
                                      .whenComplete(() => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage(),
                                                ))
                                          }),
                                )),

                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AuthRepo {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
