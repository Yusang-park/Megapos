import 'package:capstone/Model/Market.dart';
import 'package:capstone/Widget/ProductAddDialog.dart';
import 'package:capstone/Widget/ProductDeleteDialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ItemAdd extends StatefulWidget {
  String itemNo;
  String name;
  String detail;
  String price;
  String stock;
  bool isNew;

  ItemAdd({this.itemNo, this.name, this.detail, this.price, this.stock, this.isNew});

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

  Future<void> addProduct() async {
    String image;
    if(_image != null) {
      String path = (widget.detail == null) ? (widget.name + '/normal.jpg')
                    : widget.name + '/' + widget.detail + '.jpg';

      storage.ref(path).putFile(_image);
      await storage.ref(path).getDownloadURL().then((value) => image = value);
    }else { //No image 링크
      image =
      'https://firebasestorage.googleapis.com/v0/b/capstone-43f20.appspot.com/o/No_image.png?alt=media&token=20af2af2-d931-4b08-813e-0e4e60fa053d';
    }

    return firestore
        .doc(widget.itemNo).set({
          'Name': widget.name,
          'Detail' : widget.detail,
          'Price': int.parse(widget.price),
          'Stock': int.parse(widget.stock),
          'Image' : image,
          'Keyword': keyword
        })
        .then((value) => Navigator.of(context).pop())
        .catchError((error) => print("Error"));
  }

  @override
  void initState() {
    //상품 추가라면 문서번호 미리 생성하기
    if(widget.isNew)
      firestore.add({
        'Name' : '임시상품'
      }).then((value) => widget.itemNo = value.id)
      .catchError((onError) => print("Error"));

    controller[0].text = widget.name;
    controller[1].text = widget.detail;
    controller[2].text = widget.price;
    controller[3].text = widget.stock;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: (){ //뒤로가기 버튼을 눌러서 pop할 경우
        deleteProduct();
        return Future(() => true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, //키보드 올라올 때 오버플로우 발생 방지
        body: Column(
          children: [
            Container(
              //상품 등록 타이틀
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top), //상태바 크기만큼 위쪽 마진
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '상품 등록',
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
                    decoration: InputDecoration(labelText: '상품명'),
                    controller: controller[0],
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '상품 디테일'),
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
                      height: size.height * 0.4,
                      margin: EdgeInsets.only(top: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black54),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_camera,
                                    size: 20.0,
                                  ),
                                  Text("상품 이미지 업로드")
                                ],
                              )
                            : Image.file(_image),
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
                        onPressed: () async {
                          setState(() {
                            widget.name = controller[0].text;
                            widget.detail = controller[1].text;
                            widget.price = controller[2].text;
                            widget.stock = controller[3].text;

                            makeKeyword();
                          });

                          bool isAdd = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ProductAddDialog(itemNo: widget.itemNo);
                              });

                          if (isAdd)
                            addProduct();

                        },
                        child: Text(
                          '등록',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          //미리 만들어둔 문서ID 삭제
                          if(widget.isNew)
                            deleteProduct();

                          Navigator.pop(context);
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        onPressed: widget.isNew
                            ? null
                            : () async {
                                bool isDelete = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ProductDeleteDialog();
                                    });

                                deleteProduct();


                                Navigator.of(context).pop();
                              },
                        child: Text(
                          '삭제',
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
      ),
    );
  }

  Future<void> deleteProduct() {
    return firestore
        .doc(widget.itemNo)
        .delete()
        .then((value) => print("*************************8Product Deleted ${widget.itemNo}"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
