import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

/*깃헙 테스트 커밋*/
/*
  상품과 관련된 클래스들을 모아 놓았습니다.
  상품 클래스  --> Item
  선택된 상품 클래스 -->   ItemTile
  장바구니 클래스 --> Basket
 */

class Item {
  final String no; //상품 번호
  final String name; //상품 이름
  final int price; //가격
  final int stock; //재고량
  //String image;   //이미지 URL

  const Item({this.no, this.name, this.price, this.stock});
}

/* 리스트(장바구니)에 담길 선택된 상품의 타일(리스트 아이템) */
class ItemTile extends StatefulWidget {
  Item item; //선택된 상품
  int selectedStock = 1; //선택된 수량

  ItemTile({@required this.item});

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size; //기기의 화면 사이즈 정보

    return Container(
      height: deviceSize.height * 0.15, //세로 : 기기 화면의 0.15배만큼
      width: deviceSize.width * 0.9, //가로 : 기기 화면의 0.9배만큼
      margin: EdgeInsets.only(left: 10, right: 10),

      //가로를 10등분해서 이미지 3칸, 상품이름 및 가격 4칸, 마이너스버튼 1칸, 수량 텍스트 1칸, 플러스버튼 1칸 차지하도록 짜보겠음
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, //위아래 가운데 정렬
        children: [
          //상품의 이미지   -- 나중에 이미지로 변경 요망
          Expanded(
            flex: 3,
            child: Container(
              height: deviceSize.height * 0.15 * 0.9, //아이템 리스트의 0.9높이만큼
              width: deviceSize.height * 0.15 * 0.9, //가로세로 같은 정사각형
              margin: EdgeInsets.only(
                  left: 5.0, right: 15.0), //왼쪽 마진 5.0, 오른쪽 마진 15.0
              color: Colors.indigo, //색 채우기 -- 보여주기위함
            ),
          ),

          //상품명과 상품의 가격
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
              children: [
                Text(
                  //상품명
                  widget.item.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  //상품 가격
                  '${(widget.item.price) * (widget.selectedStock)}' + '원',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),

          //수량 마이너스 버튼
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.remove, size: 20),
              onPressed: _removeStock,
            ),
          ),

          //수량을 표시할 텍스트
          Expanded(
            flex: 1,
            child: Text(
              widget.selectedStock.toString(),
              textAlign: TextAlign.center, //가운데 정렬
              style: TextStyle(fontSize: 20),
            ),
          ),

          //수량 플러스 버튼
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 20,
              ),
              onPressed: _plusStock,
            ),
          ),
        ],
      ),
    );
  }

  //수량 감소
  void _removeStock() {
    //수량이 0이되었을 때 아이템 목록 제거 하기로 했던가? 설계문서 봐야겠군
    setState(() {
      if (widget.selectedStock > 0) widget.selectedStock--;
    });
  }

  //수량 증가
  void _plusStock() {
    //재고량 이상 플러스버튼 누를 때 알림메시지를 띄워야할까?
    setState(() {
      if (widget.selectedStock < widget.item.stock) widget.selectedStock++;
    });
  }
}

//장바구니 클래스, ItemTile(선택된 상품)을 리스트로 가진다.
// ignore: must_be_immutable
class Basket extends StatefulWidget {
  List<ItemTile> basket; //장바구니는 선택된 상품(ItemTile)을 리스트로 가짐

  Basket() {
    basket = [];
  }

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  //NFC 설정을 위한 변수
  bool _supportsNFC = false;
  StreamSubscription<NDEFMessage> _stream; //도라버리겟네

  void initState() {
    // TODO: implement initState

    //NFC 초기화
    NFC.isNDEFSupported //기기의 NFC 가 활성화 되어있는지 체크
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });

    //NFC 태그로부터 정보 읽어오는 함수 호출
    getItemFromNFC();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //기기의 NFC 가 비활성화 상태인 경우
    if (!_supportsNFC) {
      return Center(
        child: Text(
          "NFC 기능을 활성화 시켜 주세요.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
        itemCount: widget.basket.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.basket[index];
        });
  }

  //NFC로부터 상품 번호를 읽어와 DB에 넘기는 기능을 하게씀... 이렇게 설계했었던가 싶네
  void getItemFromNFC() {
    String itemNo;

    setState(() {
      _stream = NFC
          .readNDEF(
        once: false,
        throwOnUserCancel: false,
      )
          .listen((NDEFMessage message) {
        itemNo = message.payload.toString();
        print("itemNo: " + itemNo); //테스트용

        bool isSelected = false;
        int i;
        for (i = 0; i < widget.basket.length; i++) {
          if (itemNo == widget.basket[i].item.no) {
            isSelected = true;
            break;
          }
        }

        if (isSelected) //이미 선택된 상품이라면
          widget.basket[i]
              .selectedStock++; //-->재고량은 증가하는데 화면이 안바뀜 큰일이구만 -> _ItemTileState의 plusStock()함수를 호출하면 Best!
        else
          //파이어베이스에서 상품번호 넘기고 데이터 가져와 상품 추가
          getItemFromDB(itemNo);

        //_stream?.cancel();  ->이게 있어야할것같기도하고아닌것같기도하고없어도되는데 왜있어야할까알수가엄네
      }, onError: (e) {
        // Check error handling guide below
      });
    });
  }

  //파이어베이스에서 상품번호를 가지고 데이터를 가져와 ItemTile(선택된 상품)을 만들고, 장바구니(Basket)에 추가하는 함수
  //이렇게 적고보니 결합도가 너무 높아보이는걸?
  void getItemFromDB(String itemNo) {
    print('프롬디비 no : $itemNo 호출됨'); //테스트
    CollectionReference item = FirebaseFirestore.instance.collection('Product');

    var tmpItem;

    item.doc(itemNo).get().then((DocumentSnapshot document) {
      tmpItem = Item(
        no: itemNo,
        name: document.data()['Name'],
        price: document.data()['Price'],
        stock: document.data()['Stock'],
      );

      setState(() {
        widget.basket.add(new ItemTile(item: tmpItem));
      });
    });

    makeAlert(); //효과음 발생
    makeMessage(tmpItem.name); //메시지 발생 -->작동안함
  }

  //효과음 발생 함수
  void makeAlert() {
    final assetsAudioPlayer = new AssetsAudioPlayer();

    assetsAudioPlayer.open(
      Audio("assets/audios/bell.mp3"),
    );
  }

  //스낵바(상품이추가되었습니다) 알리는 함수 -->작동안함
  void makeMessage(String name) {
    final snackBar = SnackBar(
      content: Text('$name 이 추가되었습니다.'),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
