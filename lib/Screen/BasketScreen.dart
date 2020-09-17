import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Model/payment.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:capstone/Widget/ConfirmDialog.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../Model/payment.dart';

import '../Model/SelectedItem.dart';

StreamController<int> sumStream = StreamController(); //장바구니 총 합계 스트림

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  TextEditingController _searchController = TextEditingController();
  List<BasketTile> _list = [];
  int _sumPrice = 0;
  FlutterTts flutterTts = FlutterTts();

  Future _speak(String str) async {
    flutterTts.setLanguage("ko-KR");
    flutterTts.setPitch(0.85);
    print(await flutterTts.getVoices);
    await flutterTts.speak(str);
  }

  @override
  void initState() {
    _tagStream();
    _sumStream();
    super.initState();
  }

  void _sumStream() {
    StreamSubscription streamSubscription = sumStream.stream.listen((data) {
      setState(() {
        _sumPrice = _sumPrice + data;
      });
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

      if (itemNo == null) {
        //태그 오류로 상품번호가 Null이면 처리하는 부분
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("가격표에 다시 한번 태그해주세요!")));
        _speak("가격표에 다시 한번 태그해주세요");
      } else {
        //TODO : 태그사운드를 출력해야함.
        //이미 장바구니에 담긴 아이템이라면
        for (int i = 0; i < _list.length; i++) {
          if (_list[i].itemNo == itemNo) {
            print('장바구니 카운트 +1');
            _trigger = true;
            _list[i].ctrl.sink.add(true); //basketTile stream에 전송
          }
        }
        //TODO : 이미지가 없을때 처리가 필요함.
        if (_trigger == false) {
          if (itemNo == "null") {
            _speak("잘못된 상품정보입니다. ");
            return;
          }
          setState(() {
            _list.add(BasketTile(
              itemNo: itemNo,
              selectedItem: loadDB(itemNo),
              removeMethod: removeTile,
            ));
//            for (int i = 0; i < _list.length; i++) {
//              _sumPrice = ++_list[i].selectedItem.sumPrice;
//            }
          });
        }
      }
    });
  }

  //delect tile
  void removeTile(BasketTile removeTile) {
    setState(() {
      _list.remove(removeTile);
      print('삭제함수작동');
    });
  }

//reset Basket
  void resetBasket() {
    _list.clear();
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
              //TODO : 리스트뷰를 스크롤바로 감싸고싶은데 안되네
              Expanded(
                flex: 1,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _list[index];
                    }),
              ),

              Padding(
                padding: EdgeInsets.only(right: width * 0.04),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '결제 금액 :  $_sumPrice 원',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Payment()));
                          //TODO : 결제부분 만들기.
                        },
                        child: Text('결제하기'),
                      )),
                  SizedBox(width: width * 0.05),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: RaisedButton(
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
                      textColor: Colors.white,
                      child: Text('장바구니 비우기'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ]));
  }
}
