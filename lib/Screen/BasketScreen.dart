import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {

TextEditingController _searchController = TextEditingController();
List<BasketTile> _list = [];

  @override
  void initState() {
   // TODO: implement initState
    addItem();
    super.initState();
  }

  void addItem(){
    StreamSubscription<NDEFMessage> _stream;
    String itemNo;

    _stream = NFC.readNDEF(
      once: false,
      throwOnUserCancel: false,
    ).listen((NDEFMessage message) {
      itemNo = message.payload.toString();

      setState(() {
        print(itemNo);
        print('블라블라');
        _list.add(BasketTile());

      });

//똑같은 물품을 찍었을 때 여기서 처리해야함.

    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final vertical = height*0.02;
    final horizontal = width*0.02;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return
      Padding(padding: EdgeInsets.only(left: horizontal, right: horizontal, top: statusBarHeight),
    child:
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

      Container(child: Text('매장명이 들어가는 텍스트'),),
      Divider(thickness: 1,)
      ,Container(
 padding: EdgeInsets.only(left: width*0.05),
        margin: EdgeInsets.only(bottom: height*0.01),
        width: width*0.85,
        height: height*0.06,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
        color: Colors.black12),
        child: Row(children: [
          Flexible(child: TextField(
             controller: _searchController,
            decoration: InputDecoration.collapsed(hintText: "상품명을 검색하세요."),
          ), flex: 9,),
          IconButton(icon: Icon(Icons.search,),onPressed: (){
            _searchController.clear();
          },),
        ],),),
          Flexible(flex: 1, child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index){
                return _list[index];
              })),
      ]
    ));
  }
}
