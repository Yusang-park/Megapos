import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchSubScreen extends StatefulWidget {
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
      if (data == null) {
        setState(() {
          list.clear();
        });
      } else {
        list.clear();
        CollectionReference firebase = FirebaseFirestore.instance
            .collection('Store')
            .doc('0')
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

                list.add(map);
              }),
              setState(() {})
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return list.length == 0
        ? Expanded(
            child: Text('상품 명을 입력하세요.'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Text(list[index]['Name']);
            },
            itemCount: list.length,
          );

    // return Expanded(
    //     flex: 1,
    //     child: Center(
    //         child: Text(
    //       '검색할 상품 명을 입력하세요.',
    //       overflow: TextOverflow.clip,
    //       textAlign: TextAlign.center,
    //     )));
  }
}
