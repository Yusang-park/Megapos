import 'dart:async';

import 'package:capstone/Model/SelectedItem.dart';
import 'package:capstone/Screen/BasketScreen.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class BasketTile extends StatefulWidget {
  BasketTile({
    Key key,
    this.itemNo,
    this.selectedItem,
    this.removeMethod,
  }) : super(key: key);
  final StreamController ctrl = StreamController();
  String itemNo;
  SelectedItem selectedItem;
  Function removeMethod;

  @override
  _BasketTileState createState() => _BasketTileState();
}

class _BasketTileState extends State<BasketTile> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _tagStream(); //NFC 스트림
    loadDB();
  }

  void  _sumStream(int value){
    sumStream.sink.add(value);
  }

  void _tagStream() {
    //Stream from BasketScreen, 상품 중복 태그시 처리 부분
    StreamSubscription subscription = widget.ctrl.stream.listen((data) {
      increasCount();
    });
  }

  void loadDB() {
    //3초마다 DB로드가 완료되었는지 검사
    Timer.periodic(Duration(milliseconds: 3), (timer) {
      if (widget.selectedItem.item.name != null &&
          widget.selectedItem.item.price != null) {
        //loop종료
        timer.cancel();
        //load된 DB를 화면에 갱신
        setState(() {
          widget.selectedItem.sumPrice = widget.selectedItem.item.price;
          _sumStream(widget.selectedItem.item.price);
          _isLoaded = true; //true면 화면 데이터가 DB데이터로 변경
        });
      }
    });
  }

//TODO : 재고가 마이너스가 되어도 되는지 고민해보아야함.

  void increasCount() {
    setState(() {
      widget.selectedItem.count++;
      widget.selectedItem.sumPrice =
          widget.selectedItem.count * widget.selectedItem.item.price;
    });
    _sumStream(widget.selectedItem.item.price);
    if (widget.selectedItem.item.stock < widget.selectedItem.count) {
      //스낵바(toast) 메시지
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('현재 재고보다 많은 수량이 담겼습니다.\n구매할 수량을 확인해주세요.'),
        //TODO : 안내사운드와 바코드 사운드를 출력해야함.
      ));
    }
  }

//TODO : 수량이 0이되면 위젯 삭제 -> stream 사용이 더 옳은지 고민해야함.
  void decreasCount() {
    setState(() {
      widget.selectedItem.count--;
      widget.selectedItem.sumPrice =
          widget.selectedItem.item.price * widget.selectedItem.count;
    });
    _sumStream(-widget.selectedItem.item.price);
    if (widget.selectedItem.count < 1) {
      print('정상');
      widget.removeMethod(widget);
      dispose(); //close widet, 반드시 필요함.
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
                    child: Image.asset(
                      widget.selectedItem.item.image, //★이미지가 assets과 연동되도록 변경요망
                      height: height * 0.07,
                    ))
                : CircleAvatar(
                    radius: 1,
                  ),
            SizedBox(
              width: width * 0.01,
            ),
            _isLoaded ? Text(widget.selectedItem.item.name) : Text('   '),
            Spacer(
              flex: 1,
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.indeterminate_check_box),
              onPressed: () {
                decreasCount();
              },
            ),
            _isLoaded
                ? Text(widget.selectedItem.count.toString())
                : Text('    '),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.add_box),
              onPressed: () {
                increasCount();
              },
            ),
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
