import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class BasketTile extends StatefulWidget {
  BasketTile({Key key, this.itemNo, this.selectedItem}) : super(key: key);
  final StreamController ctrl = StreamController();
  String itemNo;
  SelectedItem selectedItem;

  @override
  _BasketTileState createState() => _BasketTileState();
}

class _BasketTileState extends State<BasketTile> {
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tagStream(); //NFC 스트림
    loadDB();
  }

  void _tagStream() {
    StreamSubscription subscription = widget.ctrl.stream.listen((data) {
      setState(() {});
    });
  }

  void loadDB() {
    Timer.periodic(Duration(milliseconds: 3), (timer) {
      if (widget.selectedItem.item.name != null && //DB로드가 완료되었는지 검사
          widget.selectedItem.item.price != null) {
        timer.cancel(); //loop종료
        setState(() {
          _isLoaded = true; //DB로드 완료를 알리는 bool
        });
      }
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

    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Container(
        height: height * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12, width: 3)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.04,
            ),
            Image.asset(
              'assets/images/0.jpg', //이부분도 수정요망
              height: height * 0.08,
            ),
            _isLoaded ? Text(widget.selectedItem.item.name) : Text('   '),
            Spacer(
              flex: 1,
            ),
            IconButton(
              icon: Icon(Icons.indeterminate_check_box),
              onPressed: () {
                setState(() {
                  if (widget.selectedItem.count > 0)
                    widget.selectedItem.count--;
                });
              },
            ),
            _isLoaded
                ? Text(widget.selectedItem.count.toString())
                : Text('    '),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                setState(() {
                  widget.selectedItem.count++;
                });
              },
            ),
            _isLoaded
                ? Text(
                    widget.selectedItem.item.price.toString() + '원',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.04),
                  )
                : Text('     '),
            SizedBox(
              width: width * 0.04,
            )
          ],
        ),
      ),
    );
  }

//  }
}
