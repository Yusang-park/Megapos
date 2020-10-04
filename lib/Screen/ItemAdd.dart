import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemAdd extends StatefulWidget {
  String itemNo;
  String name;
  String price;
  String stock;

  ItemAdd({this.itemNo, this.name, this.price, this.stock});


  @override
  _ItemAddState createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  List<String> keyword = ['garbage'];

  File _image;
  final picker = ImagePicker();

  //TODO : 매장번호바꾸기
  CollectionReference firestore = FirebaseFirestore.instance
      .collection('Store')
      .doc('0')
      .collection('Product');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List<TextEditingController> controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void makeKeyword() {
    keyword.clear();
    int i, j;

    print(widget.name.length);
    for (i = 0; i <= widget.name.length - 1; i++) {
      for (j = i + 1; j <= widget.name.length; j++) {
        keyword.add(widget.name.substring(i, j));
        print(widget.name.substring(i, j));
      }
    }
  }


  Future<void> addProduct() async{
    await firebase_storage.FirebaseStorage.instance
        .ref('Product/' + widget.itemNo + '.jpg')
        .putFile(_image);

    return firestore
        .doc(widget.itemNo)
        .set({
          'Name': widget.name,
          'Price': int.parse(widget.price),
          'Stock': int.parse(widget.stock),
          'Keyword': keyword
        })
        .then((value) => print("Product Added"))
        .catchError((error) => print("Error"));
  }

  @override
  void initState() {
    controller[0].text = widget.itemNo;
    controller[1].text = widget.name;
    controller[2].text = widget.price;
    controller[3].text = widget.stock;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false, //키보드 올라올 때 오버플로우 발생 방지
      body: Column(
        children: [
          Container(
            //상품 추가 타이틀
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
          Container(
            //상품 정보를 입력받는 필드
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: '상품 번호'),
                  enabled: false,
                  controller: controller[0],
                ),
                TextField(
                  decoration: InputDecoration(labelText: '상품 이름'),
                  controller: controller[1],
                ),
                TextField(
                  decoration: InputDecoration(labelText: '상품 가격'),
                  controller: controller[2],
                ),
                TextField(
                  decoration: InputDecoration(labelText: '현 재고량'),
                  controller: controller[3],
                ),
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    //TODO: 제스처디텍터로 감싸기 & 사진 업로드 방법 고민해보기
                    height: size.height * 0.4,
                    margin: EdgeInsets.only(top : 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black54),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: _image == null ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 20.0,
                          ),
                          Text("상품 이미지 업로드")
                        ],
                      ) : Image.file(_image),
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
                      onPressed: () {
                        setState(() {
                          widget.itemNo = controller[0].text;
                          widget.name = controller[1].text;
                          widget.price = controller[2].text;
                          widget.stock = controller[3].text;

                          makeKeyword();
                        });

                        for (int i = 0; i < 4; i++) {
                          controller[i].clear();
                        }
                        addProduct();
                      },
                      child: Text(
                        '저장',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
