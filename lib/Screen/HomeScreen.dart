import 'package:capstone/Screen/CartBody.dart';
import 'package:capstone/Screen/HomeBody.dart';
import 'package:capstone/Screen/MypageBody.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.nfcMessage});
  final nfcMessage;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidget = [
      HomeBody(['1', '2']),
      CartBody(),
      MypageBody()
    ];
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final vertical = height * 0.02;
    final horizontal = width * 0.02;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nfcMessage.toString()),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        child: bodyWidget[_selectedIndex],
        padding: EdgeInsets.only(top: statusBarHeight),
      ),
      bottomNavigationBar: navi(),
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
