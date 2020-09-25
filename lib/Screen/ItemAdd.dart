import 'package:capstone/Model/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ItemAdd extends StatefulWidget {
  @override
  _ItemAddState createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  String itemNo;
  String name;
  int price;
  int stock;
  List<String> keyword = [ 'garbage'];

  //파이어베이스 설정을 위한 변수
  bool _initialized = false;
  bool _error = false;

  //파이어베이스 초기화 함수
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire(); //파이어베이스 초기화

    super.initState();
  }





  //String imageURL;          //TODO: 이미지 어떻게 할지 고민

  List<TextEditingController> controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void makeKeyword(){
    keyword.clear();
    int i, j;

    print(name.length);
    for(i = 0; i <= name.length - 1; i++){
      for(j = i+ 1; j <= name.length ; j++){
        keyword.add(name.substring(i, j));
        print(name.substring(i, j));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //TODO : 매장번호바꾸기
    CollectionReference firestore = FirebaseFirestore.instance.collection('Store').doc('0').collection('Product');

    Future<void> addProduct(){
      return firestore.doc(itemNo).set({
        'Name' : name,
        'Price' : price,
        'Stock' : stock,
        'Keyword' : keyword
      }).then((value) => print("Product Added"))
          .catchError((error) => print("Error"));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,      //키보드 올라올 때 오버플로우 발생 방지
      body: Column(
        children: [
          Container(              //상품 추가 타이틀
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top), //상태바 크기만큼 위쪽 마진
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '상품 추가',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(
                  thickness: 2,
                )
              ],
            ),
          ),

          Container(          //상품 정보를 입력받는 필드
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("상품 번호"),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: controller[0],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        //상품 번호를 자동으로 생성해주는 버튼
                        icon: Icon(Icons.autorenew),
                        onPressed: (){
                          //TODO : ItemManage 페이지에서 인덱스를 얻어오자 어때!
                        }
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("상품 이름"),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: controller[1],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("상품가격"),
                    ),
                    Expanded(
                      flex: 5,
                      child:TextField(
                        controller: controller[2],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("현재고량"),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: controller[3],
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("상품 이미지")),
                Container(
                  //TODO: 제스처디텍터로 감싸기
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black54),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          size: 20.0,
                        ),
                        Text("상품 이미지 업로드")
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton( 
                      //TODO : DB업로드
                      onPressed: () {
                        setState(() {
                          itemNo = controller[0].text;
                          name = controller[1].text;
                          price = int.parse(controller[2].text);
                          stock = int.parse(controller[3].text);

                          makeKeyword();
                        });


                        for(int i = 0; i < 4; i++){
                          controller[i].clear();
                        }
                        addProduct();
                      },
                      child: Text(
                        '저장',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),RaisedButton(
                      //TODO : 이전페이지로
                      onPressed: () {},
                      child: Text(
                        '취소',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
