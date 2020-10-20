import 'dart:async';

import 'package:capstone/Model/Market.dart';
import 'package:provider/provider.dart';
import 'package:capstone/Screen/BasketScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchSubScreen extends StatefulWidget {
  @override
  _SearchSubScreenState createState() => _SearchSubScreenState();
  final StreamController<String> streamController =
      StreamController.broadcast();
  final StreamController<bool> streamClearController =
      StreamController.broadcast();
  StreamSubscription streamSubscription;
}

class _SearchSubScreenState extends State<SearchSubScreen> {
  Map<String, dynamic> map;
  bool clearMode = false;
  List<Map> list = List();
  @override
  void initState() {
    _reloadStream();
    _clearStream();
    super.initState();
  }

  _clearStream() {
    widget.streamClearController.stream.listen((data) {
      setState(() {
        list.clear();
        clearMode = true;
      });
    });
  }

  _reloadStream() {
    widget.streamSubscription = widget.streamController.stream.listen((data) {
      clearMode = false;
      List<Map> tempList = List();
      CollectionReference firebase = FirebaseFirestore.instance
          .collection('Store')
          .doc(context.read<Market>().marketNo)
          .collection('Product');

      firebase.where('Keyword', arrayContains: data).get().then((value) => {
            value.docs.forEach((doc) {
              map = Map<String, dynamic>();
              map['itemNo'] = doc.id;
              map['Name'] = doc.data()['Name'];
              print(map['Name']);
              map['Price'] = doc.data()['Price'];
              map['Stock'] = doc.data()['Stock'];
              map['Image'] = doc.data()['Image'];
              print(map['Price']);
              print(map['Stock']);
              print(map['Image']);

              list = tempList;
              list.add(map);
            }),
            setState(() {})
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return (list.length == 0 || clearMode == true)
        ? Padding(
            padding: EdgeInsets.only(bottom: height / 3),
            child: Center(
              child: Text('상품 명을 입력하세요.'),
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
              indent: width * 0.06,
              endIndent: width * 0.06,
              thickness: 1,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return listTile(width, height, index);
            },
            itemCount: list.length,
          );
  }

  Widget listTile(width, height, index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        children: [
          itemImage(index, width),
          SizedBox(
            width: width * 0.07,
          ),
          SizedBox(
            width: width * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list[index]['Name'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(list[index]['Price'].toString() + '원')
              ],
            ),
          ),
          Text('재고 ' + list[index]['Stock'].toString()),
          Spacer(),
          RaisedButton(
              onPressed: () {
                addStream.sink.add(list[index]['itemNo']);
                //TODO : 장바구니 담기하면, 장바구니 화면으로 넘어갔으면 좋겠음!
              },
              child: Text(
                '장바구니\n담기',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget itemImage(index, width) {
    return Image.network(
      list[index]['Image'],
      width: width * 0.1,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/1.jpg', //TODO : 에러 이미지 필요 없을 듯! 노이미지 만들어놨음
          width: width * 0.1,
        );
      },
    );
  }
}
