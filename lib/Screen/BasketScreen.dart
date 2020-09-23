import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Model/payment.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:capstone/Widget/ConfirmDialog.dart';
import 'package:capstone/Widget/TTS.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import '../Model/payment.dart';
import '../Screen/UserInfo.dart';

import '../Model/SelectedItem.dart';
import '../Widget/BasketTile.dart';

StreamController<List<dynamic>> changeStream =
    StreamController.broadcast(); //타일의 내용이 변경되었을 때 사용

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  TextEditingController _searchController = TextEditingController();
  List<BasketTile> _list = [];

  int _sumPrice = 0;

  @override
  void initState() {
    _tagStream();
    _changeStream();
    super.initState();
  }

  void fireload() {
    CollectionReference firebase = FirebaseFirestore.instance
        .collection('Store')
        .doc('0')
        .collection('Product');

    firebase.doc('1').get().then((DocumentSnapshot document) {
      print(document.data()['Name']);
    });
  }

  void _changeStream() {
    StreamSubscription streamSubscription = changeStream.stream.listen((data) {
      if (data[1] != null) {
        //0번 요소가 null이면 removeTile
        _list.remove(data[1]); //1번 요소는 Tile 객체
      }
      _sumPrice = _sumPrice + data[0];
    });
  }

  void _tagStream() {
    StreamSubscription<NDEFMessage> _stream;
    String itemNo;
//NFC 스트림
    _stream = NFC
        .readNDEF(
      once: false,
      throwOnUserCancel: false,
    )
        .listen((NDEFMessage message) {
      itemNo = message.payload.toString();
//NFC 끝
      bool _trigger = false;
      print('상품번호 : ' + itemNo);

      if (itemNo == "null") {
        //태그 오류로 상품번호가 Null이면 처리하는 부분
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("가격표에 다시 한번 태그해주세요!")));
        speak("가격표에 다시 한번 태그해주세요");
        return;
      } else {
        //이미 장바구니에 담겨있는지 확인한다.
        for (int i = 0; i < _list.length; i++) {
          if (_list[i].itemNo == itemNo) {
            _trigger = true;
            _list[i].ctrl.sink.add(true); //basketTile stream에 전송
          }
        }
        //TODO : 이미지가 없을때 처리가 필요함.
        if (_trigger == false) {
          setState(() {
            _list.add(BasketTile(
              itemNo: itemNo,
              selectedItem: loadDB(itemNo),
            ));
          });
        }
      }
    });
  }

//reset Basket
  void resetBasket() {
    _list.clear();
    _sumPrice = 0;
    setState(() {});
  }

  SelectedItem loadDB(itemNo) {
    return SelectedItem(itemNo);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final vertical = height * 0.02;
    final horizontal = width * 0.02;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
        padding: EdgeInsets.only(
            left: horizontal, right: horizontal, top: statusBarHeight),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                '매장명이 들어가는 텍스트',
                style: Theme.of(context).textTheme.title,
              )),
              Divider(
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.only(left: width * 0.05),
                margin: EdgeInsets.only(bottom: height * 0.01),
                width: width * 0.85,
                height: height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black12),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          //TODO : 파이어베이스에서 검색
                        },
                        decoration:
                            InputDecoration.collapsed(hintText: "상품명을 검색하세요."),
                      ),
                      flex: 9,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        //TODO : 리스트 뷰 스크린 필요
                        _searchController.clear();
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              StreamBuilder(
                stream: changeStream.stream,
                builder: (context, snapshot) {
                  return (_list.isEmpty
                      ? Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                            '상품을 고르신 후\n스마트폰 뒷면을 가격표에 태그하세요!',
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          )))
                      : Expanded(
                          flex: 1,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _list[index];
                              }),
                        ));
                },
              ),
              //-------------------내정보 수정을 위해 임시로넣음 진수
              Padding(
                  padding: EdgeInsets.only(
                      right: width * 0.05, bottom: height * 0.01),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserInfo()));
                        },
                        child: Icon(Icons.person),
                      )))
              //---------------------------------------------
              ,
              StreamBuilder(
                stream: changeStream.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(right: width * 0.04),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '결제 금액 :  $_sumPrice 원',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Payment()));
                    },
                    child: Text(
                      '결제하기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  RaisedButton(
                    onPressed: () {
                      showDialog(
                          //Stateful Dialog 생성하기
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return ConfirmDialog(
                                bodyText: '정말 장바구니를 비울까요?\n다시 한번 확인해주세요.',
                              );
                            });
                          }).then((value) {
                        if (value == true) {
                          resetBasket();
                        }
                      });
                    },
                    child: Text('장바구니 비우기'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _list.add(BasketTile(
                          itemNo: '1',
                          selectedItem: loadDB('1'),
                        ));
                      });
                    },
                    child: Text('가상NFC'),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ]));
  }
}
