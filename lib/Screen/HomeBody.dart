import 'package:capstone/Model/Market.dart';
import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Model/User.dart';
import 'package:capstone/Screen/BasketScreen.dart';
import 'package:capstone/Screen/CheckPaymentScreen.dart';
import 'package:capstone/Screen/ItemManage.dart';
import 'package:capstone/Screen/Receipt.dart';

import 'package:capstone/Screen/UserInfo.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:capstone/Widget/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SearchImage.dart';

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
              context.read<Market>().readFromDB('1').whenComplete(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => BasketScreen()));
              });
            },
            child: Text('장바구니')),
        RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => null));
            },
            child: Text('내정보관리')),
        RaisedButton(
            onPressed: () {
              context.read<Market>().readFromDB('1').whenComplete(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ItemManage()));
              });
            },
            child: Text('상품관리')),
        RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => GoogleSignPage()));
            },
            child: Text('회원가입')),
        RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CheckPaymentScreen()));
            },
            child: Text('거래내역 확인')),
        RaisedButton(
            onPressed: () async {
              String url = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SearchImage()));

              print("URL is $url");
            },
            child: Text('이미지검색테스트')),
      ],
    );
  }
}
