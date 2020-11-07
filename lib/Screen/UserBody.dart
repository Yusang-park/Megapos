import 'package:capstone/Controller/sign_controller.dart';
import 'package:capstone/Model/Market.dart';
import 'package:capstone/Model/User.dart';
import 'package:capstone/Screen/ItemManage.dart';
import 'package:capstone/Screen/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'CheckPaymentScreen.dart';
import 'MarketAdd.dart';

class UserBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SignController signController = SignController(context);
    Size size = MediaQuery
        .of(context)
        .size;
    double width = size.width;
    double height = size.height;
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width*0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.8,
                      margin: EdgeInsets.only(top: 20.0),
                      child:
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "안녕하세요. MEGAPOS입니다.",
                          style: TextStyle(
                            fontFamily: "Jalnan",
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    /** 로그인 되어 있다면, 유저 정보를 보여줌 **/
                    if (userModel.isSigned)
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(15),
                          width: width * 0.8,
                          child: Row(
                            children: [
                              ClipOval(
                                  child: Image.network(userModel.user?.photoURL)),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      '${userModel.user?.displayName} 님',
                                      style: TextStyle(
                                        fontFamily: 'Jalnan',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(userModel.user?.email),
                                  ),
                                  RaisedButton(
                                      onPressed: () {
                                        signController.signOut();
                                        userModel.isSigned = false;
                                      },
                                      child: Text('SignOut')),
                                ],
                              )
                            ],
                          )),
                    /** 로그인 되어 있지 않다면, 구글 로그인 버튼을 보여줌 **/
                    if(!userModel.isSigned)
                      GestureDetector(
                          onTap: () {
                            signController.signInWithGoogleAccount();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
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
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/images/googleLogo.png',
                                  width: 30,
                                ),
                                Text('SING IN with Google',
                                style: TextStyle(
                                  fontFamily: 'Jalnan',
                                  fontSize: 16
                                ),),
                              ],
                            )
                          )
                      ),

                          if (userModel.isSigned)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CheckPaymentScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
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
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '결제 내역 확인',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        ),
                      ),
                    ),

                    if (userModel.isSigned)
                      GestureDetector(
                        onTap: () async{
                          if(userModel.authState == "Manager") {
                            await context.read<Market>().readFromDB(userModel.marketNo).whenComplete((){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ItemManage()));
                            });
                          }else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MarketAdd(
                                          market: Market(),
                                          isNew: true,
                                        )));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(15),
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
                                offset:
                                Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userModel.authState == "Manager" ? '매장 관리하기' :
                                '매장 등록하기',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Icon(Icons.arrow_right)
                            ],
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("MEGAPOS 이용 방법",
                        style: TextStyle(
                          fontFamily: 'Jalnan',
                          fontSize: 22
                        ),),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical : 15.0),
                      child: Image.asset("assets/images/howto.png")
                    )
//                  if (userModel.isSigned)
//                    Container(
//                      padding: EdgeInsets.all(10),
//                      margin: EdgeInsets.all(15),
//                      // height: 100,
//                      width: width * 0.8,
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(10),
//                            topRight: Radius.circular(10),
//                            bottomLeft: Radius.circular(10),
//                            bottomRight: Radius.circular(10)),
//                        boxShadow: [
//                          BoxShadow(
//                            color: Colors.grey.withOpacity(0.5),
//                            spreadRadius: 5,
//                            blurRadius: 7,
//                            offset: Offset(0, 3), // changes position of shadow
//                          ),
//                        ],
//                      ),
//
//                      child: Column(
//                        children: [
//                          Text(userModel.user?.displayName),
//                          Text(userModel.user?.uid),
//                          Text('제공정보 : ' +
//                              userModel.user?.providerData.toString()),
//                          Text('로그인 기록 : ' +
//                              userModel.user?.metadata.toString()),
//                          RaisedButton(
//                              onPressed: () {
//                                signController.signOut();
//                              },
//                              child: Text('SignOut')),
//                          Text(userModel.authState),
//                        ],
//                      ),
//                    ),
//                  if (!userModel.isSigned)
//                    RaisedButton(
//                      onPressed: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => SignUpPage()),
//                        );
//                      },
//                      child: Text('로그인 페이지'),
//                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
