import 'package:capstone/Controller/sign_controller.dart';
import 'package:capstone/Model/User.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    SignController signController = SignController(context);
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(context.watch<UserModel>().user?.displayName.toString()),
            Icon(Icons.ac_unit), //TODO: 로고
            Container(
              width: width * 0.6,
              height: 40,
              child: ButtonTheme(
                  buttonColor: Colors.white,
                  child: RaisedButton(
                      onPressed: () {
                        signController.signInWithGoogleAccount();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   width: 8,
                          // ),
                          Image.asset(
                            'assets/images/googleLogo.png',
                            width: 18,
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Text('SING IN with Google'),
                        ],
                      ))),
            )
          ],
        ),
      )),
    );
  }
}
