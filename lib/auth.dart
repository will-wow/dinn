import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dinn/random-words.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User? _user;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: _signInWithGoogle,
          ),
        ],
      );
    }

    return RandomWords();
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      print('ERROR!!');
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print(credential);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
