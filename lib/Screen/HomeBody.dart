import 'package:capstone/Screen/BasketScreen.dart';
import 'package:capstone/Screen/ItemManage.dart';
import 'package:capstone/Screen/UserInfo.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BasketScreen();
                },
              ));
            },
            child: Text('장바구니')),
        RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserInfo("정성진", 'a', 'd', 'a', 'b')));
            },
            child: Text('내정보관리')),
        RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ItemManage()));
            },
            child: Text('상품관리')),
      ],
    );
  }
}
