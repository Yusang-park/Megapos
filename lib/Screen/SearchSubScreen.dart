import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class SearchSubScreen extends StatefulWidget {
  @override
  _SearchSubScreenState createState() => _SearchSubScreenState();
  StreamController<bool> controller = StreamController();
  List<Map> _list = [];
  List<String> _needInfo = ['Name', 'Price', 'Stock', 'Image'];

  searchResult(String value) {
//   _list.clear();
    Map<String, dynamic> _map = Map<String, dynamic>();
    CollectionReference firebase = FirebaseFirestore.instance
        .collection('Store')
        .doc('0')
        .collection("Product");
    firebase.where("Keyword", arrayContains: value).get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              for (int i = 0; _needInfo.length > i; i++) {
                _map[_needInfo[i]] = doc.data()[_needInfo[i]];
              }
              _list.add(_map); //map이 덮어 씌워짐
            }),
            controller.add(true)
          },
        );
  }
}

class _SearchSubScreenState extends State<SearchSubScreen> {
  @override
  void initState() {
    listenStream();
    super.initState();
  }

  void listenStream() {
    StreamSubscription subscription = widget.controller.stream.listen((event) {
      setState(() {
        print('gd');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Column(children: [
      FlatButton(
        child: Text('초기화'),
        onPressed: () {
          setState(() {
            print(widget._list[0]["Name"]);
          });
        },
      ),
      testwi(),
    ]);
  }

  Widget testwi() {
    if (widget._list.isNotEmpty) {
      return Text(widget._list[0]['Name']);
    }
    return Text('없음');
  }
}
