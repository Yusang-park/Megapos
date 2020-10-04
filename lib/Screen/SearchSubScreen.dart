import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchSubScreen extends StatefulWidget {
  SearchSubScreen({this.marketNo});
  final marketNo;
  @override
  _SearchSubScreenState createState() => _SearchSubScreenState();
  final StreamController<String> streamController =
      StreamController.broadcast();
  StreamSubscription streamSubscription;
}

class _SearchSubScreenState extends State<SearchSubScreen> {
  List<Map> list = List();
  Map<String, dynamic> map;

  @override
  void initState() {
    _reloadStream();

    super.initState();
  }

  _reloadStream() {
    widget.streamSubscription = widget.streamController.stream.listen((data) {
      list.clear();
      if (data == "") {
        list.clear();
        setState(() {});
      } else {
        list.clear();
        CollectionReference firebase = FirebaseFirestore.instance
            .collection('Store')
            .doc(widget.marketNo)
            .collection('Product');

        firebase.where('Keyword', arrayContains: data).get().then((value) => {
              value.docs.forEach((doc) {
                map = Map<String, dynamic>();
                map['Name'] = doc.data()['Name'];
                print(map['Name']);
                map['Price'] = doc.data()['Price'];
                map['Stock'] = doc.data()['Stock'];
                map['Image'] = 'assets/images/' + doc.id + '.jpg';
                print(map['Price']);
                print(map['Stock']);
                print(map['Image']);
                list.remove(map);
                list.add(map);
              }),
              setState(() {})
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return list.length == 0
        ? Expanded(
            child: Padding(
            padding: EdgeInsets.only(top: height / 5),
            child: Text('상품 명을 입력하세요.'),
          ))
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
              onPressed: () {},
              child: Text(
                '장바구니\n담기', //TODO : onpress 만들어야함
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget itemImage(index, width) {
    return Image.asset(
      list[index]['Image'],
      width: width * 0.1,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/1.jpg', //TODO : 에러 이미지 삽입
          width: width * 0.1,
        );
      },
    );
  }
}
