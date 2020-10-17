import 'package:capstone/Controller/sign_controller.dart';
import 'package:capstone/Model/User.dart';
import 'package:capstone/Screen/login_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UserBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SignController signController = SignController(context);
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (userModel.isSigned)
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(15),
                      // height: 100,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          Text(userModel.user?.displayName),
                          Text(userModel.user?.uid),
                          Text('제공정보 : ' +
                              userModel.user?.providerData.toString()),
                          Text('로그인 기록 : ' +
                              userModel.user?.metadata.toString()),
                          RaisedButton(
                              onPressed: () {
                                signController.signOut();
                              },
                              child: Text('SignOut')),
                          Text(userModel.authState),
                        ],
                      ),
                    ),
                  if (!userModel.isSigned)
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text('로그인 페이지'),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
