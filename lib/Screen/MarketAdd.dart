import 'package:capstone/Model/Item.dart';
import 'package:capstone/Model/Market.dart';
import 'package:capstone/Model/User.dart';
import 'package:capstone/Widget/ProductAddDialog.dart';
import 'package:capstone/Widget/ProductDeleteDialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'ItemManage.dart';
import 'SearchImage.dart';

class MarketAdd extends StatefulWidget {
  Market market;
  bool isNew;

  MarketAdd({this.market, this.isNew});

  @override
  _MarketAddState createState() => _MarketAddState();
}

class _MarketAddState extends State<MarketAdd> {
  List<TextEditingController> controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<String> keyword = ['garbage'];
  int docID;

  @override
  void initState() {

    /* 문서 번호 생성하기, 문서 수 + 1인데 버그 가능성있음 */
    CollectionReference firestore = FirebaseFirestore.instance
        .collection('Store');

    docID = 0;

    firestore.get().then((value){
      value.docs.forEach((doc){
        docID++;
      });
    });
    super.initState();
  }
  /* --------------------------------------------------- */

  void makeKeyword() {
    keyword.clear();
    int i, j;

    var _name = widget.market.name;
    for (i = 0; i <= _name.length - 1; i++) {
      for (j = i + 1; j <= _name.length; j++) {
        keyword.add(_name.substring(i, j));
        print(_name.substring(i, j));
      }
    }
  }

  Future<void> setManagerInfo() async{
    String docID = context.read<UserModel>().userNo;
    CollectionReference firestore = FirebaseFirestore.instance
        .collection('User');

    String marketNo = context.read<Market>().marketNo;

    return firestore.doc(docID).set({
      'AuthState' : 'Manager',
      'MarketNo' : marketNo
    }).then((value) => print("Manager set OK"))
        .catchError((error) => print("Manager set Error"));
  }


  Future<void> addStore() async{
    setState(() {
      widget.market.marketNo = docID.toString();
    });

    await widget.market.writeToDB();
    await context.read<Market>().readFromDB(docID.toString());
    await setManagerInfo();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ItemManage()));
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        //뒤로가기 버튼을 눌러서 pop 못하게 막기!
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, //키보드 올라올 때 오버플로우 발생 방지
        body: Column(
          children: [
            Container(
              //상품 등록 타이틀
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top), //상태바 크기만큼 위쪽 마진
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '매장 등록',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  )
                ],
              ),
            ),
            Container(
              //매장 정보를 입력받는 필드
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: '매장명'),
                    controller: controller[0],
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '매장 주소'),
                    controller: controller[1],
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '대표자'),
                    controller: controller[2],
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '연락처'),
                    controller: controller[3],
                  ),

                ],
              ),
            ),
            Spacer(),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      widget.market.name = controller[0].text;
                      widget.market.address = controller[1].text;
                      widget.market.ceo = controller[2].text;
                      widget.market.contact = controller[3].text;

                      makeKeyword();
                    });


                    bool isAdd = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ProductAddDialog(No: docID.toString(), isItem: false,);
                        });

                    if (isAdd) addStore();
                  },
                  child: Text(
                    '등록',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
