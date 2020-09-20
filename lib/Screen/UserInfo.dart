import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void initiate() {
    super.initState();
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
        body: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          top: statusBarHeight, left: horizontal),
                      child: Text(
                        '프로필',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      )),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.1,
                        right: width * 0.1,
                        top: statusBarHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '이름    ',
                                style:
                                    TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: width * 0.1, top: 20),
                                width: width * 0.6,
                                height: height * 0.06,
                                child: TextField(
                                  controller: TextEditingController(),
                                  decoration:
                                      InputDecoration.collapsed(hintText: ""),
                                ),
                              ),
                            ]),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '연락처',
                                style:
                                    TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: width * 0.1, top: 20),
                                width: width * 0.6,
                                height: height * 0.06,
                                child: TextField(
                                  controller: TextEditingController(),
                                  onChanged: (value) {},
                                  decoration:
                                      InputDecoration.collapsed(hintText: ""),
                                ),
                              ),
                            ]),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '이메일',
                                style:
                                    TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: width * 0.1, top: 20),
                                width: width * 0.6,
                                height: height * 0.06,
                                child: TextField(
                                  controller: TextEditingController(),
                                  onChanged: (value) {},
                                  decoration:
                                      InputDecoration.collapsed(hintText: ""),
                                ),
                              ),
                            ]),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '주소    ',
                                style:
                                    TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: width * 0.1, top: 20),
                                width: width * 0.6,
                                height: height * 0.06,
                                child: TextField(
                                  controller: TextEditingController(),
                                  onChanged: (value) {},
                                  decoration:
                                      InputDecoration.collapsed(hintText: ""),
                                ),
                              ),
                            ]),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '우편번호',
                                style:
                                    TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: width * 0.07, top: 20),
                                width: width * 0.6,
                                height: height * 0.06,
                                child: TextField(
                                  controller: TextEditingController(),
                                  onChanged: (value) {},
                                  decoration:
                                      InputDecoration.collapsed(hintText: ""),
                                ),
                              ),
                            ]),
                        Divider(
                          thickness: 1,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text("ㅎㅎ"),
                            )),
                      ],
                    ),
                  ),
                ])));
  }
}
