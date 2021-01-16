import 'dart:async';

import 'package:capstone/Model/Market.dart';
import 'package:capstone/Screen/BasketScreen.dart';
import 'package:capstone/Screen/CartBody.dart';
import 'package:capstone/Screen/HomeBody.dart';
import 'package:capstone/Screen/UserBody.dart';
import 'package:capstone/Widget/ConfirmDialog.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  StreamSubscription<NDEFMessage> _stream;

  @override
  void initState() {
    super.initState();
    _tagStream();
  }

  void _tagStream() {
    print("홈스크린에서 nfc대기중");
    //NFC 스트림
    _stream = NFC
        .readNDEF(
      once: true,
      throwOnUserCancel: false,
    )
        .listen((NDEFMessage message) async {
      String marketNo = message.payload.toString().split("marketNo:")[1];
      print("홈스크린에서 읽음 : $marketNo");
      await context.read<Market>().readFromDB(marketNo).whenComplete(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BasketScreen()));
      });

      //NFC 끝
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stream.cancel();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidget = [HomeBody(), CartBody(), UserBody()];
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final vertical = height * 0.02;
    final horizontal = width * 0.02;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () {
        return showDialog(
          barrierDismissible: false,
            context: context,
        builder: (context){
          return ConfirmDialog(height: height * 0.5, width: width * 0.6, bodyText: "정말 종료하실건가요?",);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('MEGAPOS',
          style: TextStyle(
            fontFamily: 'Jalnan'
          ),),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: UserBody(),
//      body: Padding(
//        child: bodyWidget[_selectedIndex],
//        padding: EdgeInsets.only(top: statusBarHeight),
//      ),
//      bottomNavigationBar: navi(),
      ),
    );
  }

  Widget navi() {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: '장바구니'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded), label: '마이페이지'),
        ],
        onTap: (value) {
          _onItemTapped(value);
        });
  }
}
