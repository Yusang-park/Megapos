import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProductDeleteDialog extends StatefulWidget {
  @override
  _ProductDeleteDialogState createState() => _ProductDeleteDialogState();
}

class _ProductDeleteDialogState extends State<ProductDeleteDialog> {
  bool isDeleted = false;


  void popWithTrue(){
    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 10.0,
      insetPadding: EdgeInsets.all(8.0),
      title:  Text("상품 삭제",
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Jalnan',
            color: Colors.deepPurple
        ),),
      actions: isDeleted ? null : [
        TextButton(
          child: Text('삭제'),
          onPressed: (){
            setState(() {
              isDeleted = true;
            });

            Timer(Duration(seconds: 2), popWithTrue);
          },
        ),
        TextButton(
          child: Text('취소'),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
      ],
      content:Container(
        width: size.width * 0.7,
        height: size.height * 0.2,
        child: Center(
          child: isDeleted ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, size : 32),
              Text("삭제되었습니다.")
            ],
          )
              : Text("해당 상품을 삭제하시겠습니까?\n 삭제시 복구할 수 없습니다."),
        ),
      ),

    );
  }
}
