import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';


class ProductAddDialog extends StatefulWidget {
  String No;
  bool isItem;
  ProductAddDialog({@required this.No, @required this.isItem});

  @override
  _ProductAddDialogState createState() => _ProductAddDialogState();
}

class _ProductAddDialogState extends State<ProductAddDialog> {

  bool isTagged = false;

  @override
  void initState() {
    writeNFC();
    super.initState();
  }

  void writeNFC(){
    NDEFMessage newMessage;
    if(widget.isItem)
      newMessage = NDEFMessage.withRecords(
          [ NDEFRecord.type("coding/shudra", "itemNo:" + widget.No) ]
      );
    else{
      newMessage = NDEFMessage.withRecords(
          [ NDEFRecord.type("coding/shudra", "marketNo:" + widget.No) ]
      );
    }
    Stream<NDEFTag> stream = NFC.writeNDEF(newMessage, once: true);
    stream.listen((NDEFTag tag) {
      print("write ok");
      setState(() {
        isTagged = true;
      });
      Timer(Duration(seconds: 2), popWithTrue);
    });
  }

  void popWithTrue(){
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 10.0,
      insetPadding: EdgeInsets.all(8.0),
      title:  Text("등록",
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Jalnan',
            color: Colors.deepPurple
        ),),
      content:Container(
        width: size.width * 0.7,
        height: size.height * 0.2,
        child: Center(
              child: isTagged ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size : 32),
                  Text("잠시 후 꺼집니다")
                ],
              )
                  : Text("해당 NFC에\n 스마트폰을 태그해주세요"),
            ),
        ),
      actions: isTagged ? null : [
        TextButton(
          child: Text('취소'),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}
