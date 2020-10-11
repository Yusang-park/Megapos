import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Screen/BasketScreen.dart';
import 'package:capstone/Widget/TTS.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class BasketTile extends StatefulWidget {
  BasketTile({
    Key key,
    this.itemNo,
    this.selectedItem,
  }) : super(key: key);
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
    loadDB();
    _tagStream(); //NFC 스트림
    super.initState();
  }

  void _tagStream() {
    //Stream from BasketScreen, 상품 중복 태그시 처리 부분
    StreamSubscription subscription = widget.ctrl.stream.listen((data) {
      changeCount(true);
    });
  }

  void loadDB() async {
    //3초마다 DB로드가 완료되었는지 검사
    Timer.periodic(Duration(milliseconds: 3), (timer) {
      if (widget.selectedItem.item.name != null &&
          widget.selectedItem.item.price != null) {
        //loop종료
        timer.cancel();
        //load된 DB를 화면에 갱신
        setState(() {
          changeCount(true);
          _isLoaded = true; //true면 화면 데이터가 DB데이터로 변경
        });
      }
    });
  }

  void changeCount(bool value) {
    //count +
    if (value) {
      setState(() {
        widget.selectedItem.count++;
        widget.selectedItem.sumPrice += widget.selectedItem.item.price;
      });
      changeStream.sink.add([widget.selectedItem.item.price, null]);
      speak(widget.selectedItem.item.name + "한 개");
    } else {
      //count -
      if (widget.selectedItem.count == 1) {
        //remove tile
        // dispose();
        changeStream.sink.add([-widget.selectedItem.item.price, widget]);
      } else {
        setState(() {
          widget.selectedItem.count--;
          widget.selectedItem.sumPrice -= widget.selectedItem.item.price;
        });
        changeStream.sink.add([-widget.selectedItem.item.price, null]);
      }
    }
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
      padding: EdgeInsets.all(width * 0.03),
      child: Container(
        height: height * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12, width: 3)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.03,
            ),
            _isLoaded
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 3)),
                    child: Image.network(
                      widget.selectedItem.item.image,
                      height: height * 0.07,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network( //NO image
                          'https://firebasestorage.googleapis.com/v0/b/capstone-43f20.appspot.com/o/No_image.png?alt=media&token=20af2af2-d931-4b08-813e-0e4e60fa053d',
                          height: height * 0.07,
                        ); //TODO: 에러 이미지로 변경해야함
                      },
                    ))
                : CircleAvatar(
                    radius: 1,
                  ),
            SizedBox(
              width: width * 0.01,
            ),
            _isLoaded ? Text('${widget.selectedItem.item.name} ${widget.selectedItem.item.detail}') : Text('   '),
            Spacer(
              flex: 1,
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.indeterminate_check_box),
              onPressed: () {
                changeCount(false);
              },
            ),
            _isLoaded
                ? Text(widget.selectedItem.count.toString())
                : Text('    '),
            IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.add_box),
                onPressed: () {
                  changeCount(true);
                }),
            _isLoaded
                ? Text(
                    widget.selectedItem.sumPrice.toString() + '원',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.03),
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
}
