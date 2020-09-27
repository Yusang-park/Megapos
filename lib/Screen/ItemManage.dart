import 'package:capstone/Model/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ItemAdd.dart';

class ItemManage extends StatefulWidget {
  @override
  _ItemManageState createState() => _ItemManageState();
}

class _ItemManageState extends State<ItemManage> {
  //파이어베이스 설정을 위한 변수
  bool _initialized = false;
  bool _error = false;

  //파이어베이스 초기화 함수
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire(); //파이어베이스 초기화

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드 올라올 때 오버플로우 발생 방지
        body: Column(children: [
          Container(
            //상품 관리 타이틀
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top), //상태바 크기만큼 위쪽 마진
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '상품 관리',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("사진"),
                      Text("이름"),
                      Text("가격"),
                      Text("재고량"),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(child: ItemList()),
        ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ItemAdd()));
        },
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<Widget> list = [];
  int itemNo = -1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //TODO : 매장번호 읽어온 값으로 변경하기
    CollectionReference firestore = FirebaseFirestore.instance
        .collection('Store')
        .doc('0')
        .collection('Product');

    return FutureBuilder(
        future: firestore.get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                itemNo++;
                return ItemTile(
                  itemNo: itemNo.toString(),
                  name: document.data()['Name'],
                  price: document.data()['Price'],
                  stock: document.data()['Stock'],
                );
              }).toList(),
            );

          }else
            return Text("loading");
        });
  }
}

class ItemTile extends StatefulWidget {
  String itemNo;
  String name;
  int price;
  int stock;


  ItemTile({
    this.itemNo,
    this.name,
    this.price,
    this.stock,
});

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: size.height * 0.1,
      width: size.width * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black12, width: 3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: size.height * 0.07,
          ),
          Text(widget.name),
          Text(widget.price.toString() + '원'),
          Text(widget.stock.toString() + '개')
        ],
      ),
    );
  }
}
