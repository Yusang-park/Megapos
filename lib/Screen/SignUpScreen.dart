import 'package:capstone/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _searchController0 = TextEditingController();
  TextEditingController _searchController1 = TextEditingController();
  TextEditingController _searchController2 = TextEditingController();
  TextEditingController _searchController3 = TextEditingController();
  TextEditingController _searchController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = UserModel.noArgument();
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      SizedBox(
        height: height * 0.05,
      ),
      Container(
          alignment: Alignment.center,
          child: Text(
            '환영합니다!',
            style: Theme.of(context).textTheme.title,
          )),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 40),
        child: Column(children: [
          Row(children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "이름",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
            Container(
              width: width * 0.3,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "연락처",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
          ]),
          Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                height: 35,
                width: width * 0.3,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: TextField(
                    onChanged: (String str) {
                      userModel.name = str;
                    },
                    controller: _searchController0,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    )),
              ),
              Container(width: width * 0.07),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                height: 35,
                width: width * 0.3,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: TextField(
                    onChanged: (String str) {
                      userModel.phoneNum = str;
                    },
                    controller: _searchController1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    )),
              ),
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "이메일",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            height: 35,
            child: TextField(
                onChanged: (String str) {
                  userModel.email = str;
                },
                controller: _searchController2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                )),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "주소",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            height: 35,
            child: TextField(
                onChanged: (String str) {
                  userModel.addr = str;
                },
                controller: _searchController3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                )),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "우편번호",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            height: 35,
            child: TextField(
                onChanged: (String str) {
                  userModel.postCode = str;
                },
                controller: _searchController4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                )),
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 5),
                color: Colors.blue,
                onPressed: () {},
                child: Container(
                    alignment: Alignment.center,
                    width: width * 0.9,
                    child: Text("가입하기")),
              ))
        ]),
      ),
    ])));
  }
}
