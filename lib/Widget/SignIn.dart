import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleSignPage extends StatefulWidget {
  @override
  _GoogleSignPageState createState() => _GoogleSignPageState();
}

class _GoogleSignPageState extends State<GoogleSignPage> {
  User user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    setState(() {
      this.user = user;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          RaisedButton(
              onPressed: () {
                googleSignIn();
              },
              child: Text('google sign In')),
          user != null ? Text(user.displayName) : SizedBox(),
          user != null ? Text(user.uid) : SizedBox(),
        ]));
  }
}
