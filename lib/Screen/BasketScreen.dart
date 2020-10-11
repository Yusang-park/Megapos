import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Model/payment.dart';
import 'package:capstone/Screen/SearchSubScreen.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:capstone/Widget/ConfirmDialog.dart';
import 'package:capstone/Widget/TTS.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../Model/User.dart';
import '../Model/payment.dart';

import '../Model/SelectedItem.dart';
import '../Widget/BasketTile.dart';

StreamController<List<dynamic>> changeStream =
    StreamController.broadcast(); //타일의 내용이 변경되었을 때 사용
StreamController<String> addStream = StreamController();

class BasketScreen extends StatefulWidget {
  BasketScreen({this.marketNo});
  String marketNo = 'null';
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  TextEditingController _searchController = TextEditingController();
  List<BasketTile> _list = [];
  FocusNode _searchFocus = FocusNode();
  bool _searchMode = false;
  SearchSubScreen searchSubScreen;
  int _sumPrice = 0;
  String marketName = '';
  double _searchOpacity = 0.0;
  double _mainOpacity = 1.0;
  @override
  void initState() {
    _marketload();
    _tagStream();
    _changeStream();
    _focusListen();
    _keyListen();
    _addListen();
    super.initState();
  }

  void _marketload() {
    CollectionReference firebase =
        FirebaseFirestore.instance.collection('Store');

    firebase.doc(widget.marketNo).get().then((DocumentSnapshot document) {
      setState(() {
        marketName = document.data()['Name'];
        print('매장명 : ' + marketName);
        searchSubScreen = SearchSubScreen(
          marketNo: widget.marketNo,
        );
        speak('환영합니다 ' + marketName + '입니다');
      });
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
      itemNo = message.payload.toString().split("itemNo:")[1];
//NFC 끝
      addStream.sink.add(itemNo);
    });
  }

  void _addListen() {
    addStream.stream.listen((itemNo) {
      bool _trigger = false;
      print('상품번호 : ' + itemNo);

      if (itemNo == "null") {
        //태그 오류로 상품번호가 Null이면 처리하는 부분
        //TODO:스낵바가 작동안함
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
              selectedItem: loadDB(itemNo, widget.marketNo),
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
    // setState(() {}); 이거 안해도 되네.. 왜지
  }

  SelectedItem loadDB(itemNo, marketNo) {
    return SelectedItem(itemNo, marketNo);
  }

  _focusListen() {
    _searchFocus.addListener(() {
      //포커스 노드가 변경되었을 때 호출되는 부분
      if (_searchFocus.hasFocus) {
        setState(() {
          _searchMode = true;
        });
      } else if (!_searchFocus.hasFocus) {
        setState(() {
          _searchMode = false;
        });
      }
    });
  }

  _keyListen() {
    KeyboardVisibilityNotification().addNewListener(onHide: () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: Text(''),
        title: Text(
          marketName,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Jalnan',
              fontWeight: FontWeight.bold),
        ),
      ),

      resizeToAvoidBottomInset: false, //키보드가 올라왔을때 화면이 안밀림
      body: InkWell(
          highlightColor: Colors.transparent, //모서리로 퍼져나가는 이펙트

          splashColor: Colors.transparent, //클릭시 원형 이펙트
          onTap: () {
            setState(() {
              FocusScope.of(context)
                  .requestFocus(FocusNode()); //textfield의 포커스를 빼앗음
            });
          },
          //제스처를 하기 위한 위젯
          child: Padding(
              padding: EdgeInsets.only(
                  left: horizontal, right: horizontal, top: height * 0.02),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: width * 0.05),
                      margin: EdgeInsets.only(
                        bottom: height * 0.01,
                      ),
                      width: width * 0.85,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black12),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          TextField(
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            focusNode: _searchFocus,
                            controller: _searchController,
                            decoration: InputDecoration.collapsed(
                                hintText: "상품명을 검색하세요."),
                            onChanged: (value) {
                              if (_searchController.text == "") {
                                searchSubScreen.streamClearController.add(true);
                              } else {
                                searchSubScreen.streamController
                                    .add(_searchController.text);
                              }
                              setState(() => this);
                            },
                            onTap: () {
                              setState(() {
                                searchSubScreen.streamClearController.add(true);
                              });
                            },
                          ),
                          Positioned(
                              right: 0.0,
                              child: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.close_rounded),
                                      onPressed: () {
                                        //TODO : 리스트 뷰 스크린 필요
                                        setState(() {
                                          setState(() {
                                            _searchOpacity = 0.0;
                                            _mainOpacity = 1.0;
                                            _searchController.clear();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            LogicalKeyboardKey.close;
                                          });
                                        });
                                      },
                                    )
                                  : SizedBox()),
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: StreamBuilder(
                        stream: changeStream.stream,
                        builder: (context, snapshot) {
                          return _listWidget(width, height);
                        },
                      ),
                    ),
                    Opacity(
                      child: _bottomWidget(width, height),
                      opacity: _mainOpacity,
                    ),
                  ]))),
    );
  }

  Widget _listWidget(width, height) {
    if (_searchMode || _searchController.value.text.isNotEmpty) {
      _searchOpacity = 1.0;
      _mainOpacity = 0.0;
    } else {
      _searchOpacity = 0.0;
      _mainOpacity = 1.0;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          child: searchSubScreen,
          opacity: _searchOpacity,
        ),
        Opacity(
          opacity: _mainOpacity,
          child: _list.isEmpty
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.top * 2),
                  child: Text(
                    '상품을 고르신 후\n스마트폰 뒷면을 가격표에 태그하세요!',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _list[index];
                  }),
        ),
      ],
    );
  }

// return (_searchMode || _searchController.value.text.isNotEmpty //키보드가 올라온 상태
  // ? searchSubScreen
  // : _list.isEmpty
  //     ? Expanded(
  //         flex: 1,
  //         child: Center(
  //             child: Text(
  //           '상품을 고르신 후\n스마트폰 뒷면을 가격표에 태그하세요!',
  //           overflow: TextOverflow.clip,
  //           textAlign: TextAlign.center,
  //         )))
  //     : Expanded(
  //         flex: 1,
  //         child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: _list.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return _list[index];
  //             }),
  //       ));
  Widget _bottomWidget(width, height) {
    return Column(
      children: [
        StreamBuilder(
          stream: changeStream.stream,
          builder: (context, snapshot) {
            return Padding(
              padding: EdgeInsets.only(right: width * 0.07),
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
                        builder: (BuildContext context) =>
                            Payment(UserModel("0"), 100, "포카리스웨트")));
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
                    selectedItem: loadDB('1', widget.marketNo),
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
      ],
    );
  }
}
