import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class BasketTile extends StatefulWidget {
BasketTile({Key key,
this.itemNo
}) : super (key : key);

  String itemNo;
  SelectedItem selectedItem;


  @override
  _BasketTileState createState() => _BasketTileState();
}

class _BasketTileState extends State<BasketTile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.itemNo+ "현재 장바구니 타일입니다.");
  }

//
//  void addItem(){
//    StreamSubscription<NDEFMessage> _stream;
//    String itemNo;
//
//    _stream = NFC.readNDEF(
//      once: false,
//      throwOnUserCancel: false,
//    ).listen((NDEFMessage message) {
//      setState(() {
//
//      });
//    });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final vertical = height*0.02;
    final horizontal = width*0.02;
    final statusBarHeight = MediaQuery.of(context).padding.top;



    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Container(
        height: height*0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: Colors.black12,
                width: 3      //아닐수도
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(width: width*0.04,),
            Image.asset('assets/images/0.jpg',
              height: height * 0.08,
            ),

            Text('썬칩'),  //변경요망
            Spacer(flex: 1,),
            IconButton(
              icon: Icon(Icons.indeterminate_check_box),
              onPressed: (){},
            ),
            Text('1'),      // 변경요망
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: (){},
            ),
            Text('15000원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.04),),    //변경요망
            SizedBox(width: width*0.04,)
          ],
        ),
      ),
    );
  }

//  }
}
