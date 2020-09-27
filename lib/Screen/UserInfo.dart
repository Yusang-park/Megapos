import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();

  final String name;
  final String phoneNum;
  final String email;
  final String addr;
  final String postalCode;

  UserInfo(this.name, this.phoneNum, this.email, this.addr, this.postalCode);
}

class _UserInfoState extends State<UserInfo> {
  TextEditingController _searchController0 = TextEditingController();
  TextEditingController _searchController1 = TextEditingController();
  TextEditingController _searchController2 = TextEditingController();
  TextEditingController _searchController3 = TextEditingController();
  TextEditingController _searchController4 = TextEditingController();
  CollectionReference firestore = FirebaseFirestore.instance.collection('User');

  String name;
  String phoneNum;
  String email;
  String addr;
  String postalCode;

  @override
  initState() {
    name = widget.name;
    phoneNum = widget.phoneNum;
    email = widget.email;
    addr = widget.addr;
    postalCode = widget.postalCode;
    _searchController0.text = name;
    _searchController1.text = phoneNum;
    _searchController2.text = email;
    _searchController3.text = addr;
    _searchController4.text = postalCode;
  }

  Future<void> updateUser() {
    return firestore
        .doc('0')
        .set({
          'Name': name,
          'phoneNum': phoneNum,
          'email': email,
          'addr': addr,
          'postalCode': postalCode
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Error"));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final vertical = height * 0.02;
    final horizontal = width * 0.02;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          Text(
            '내 정보',
            style: Theme.of(context).textTheme.title,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('이름'),
                    alignment: Alignment.center,
                    width: width * 0.13,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Expanded(
                      child: Container(
                          child: TextField(
                              onChanged: (String str) => (name = str),
                              controller: _searchController0,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              )))),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('연락처'),
                    alignment: Alignment.center,
                    width: width * 0.13,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Expanded(
                      child: Container(
                          child: TextField(
                              onChanged: (String str) => (phoneNum = str),
                              controller: _searchController1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              )))),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('이메일'),
                    alignment: Alignment.center,
                    width: width * 0.13,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Expanded(
                      child: Container(
                          child: TextField(
                              onChanged: (String str) => (email = str),
                              controller: _searchController2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              )))),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('주소'),
                    alignment: Alignment.center,
                    width: width * 0.13,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Expanded(
                      child: Container(
                          child: TextField(
                              onChanged: (String str) => (addr = str),
                              controller: _searchController3,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              )))),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('우편번호'),
                    alignment: Alignment.center,
                    width: width * 0.13,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Expanded(
                      child: Container(
                          child: TextField(
                              onChanged: (String str) => (postalCode = str),
                              controller: _searchController4,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              )))),
                ],
              ),
              Divider(
                thickness: 1,
              ),
            ]),
          ),
          Spacer(
            flex: 1,
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: Align(
                child: RaisedButton(
                  onPressed: () {
                    updateUser();
                    Navigator.pop(
                        context, [name, phoneNum, email, addr, postalCode]);
                  },
                  child: Text('확인'),
                ),
                alignment: Alignment.centerRight,
              ))
        ],
      ),
    );
  }
}
