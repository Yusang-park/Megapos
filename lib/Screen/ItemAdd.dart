import 'package:capstone/Model/Item.dart';
import 'package:capstone/Model/Market.dart';
import 'package:capstone/Widget/ProductAddDialog.dart';
import 'package:capstone/Widget/ProductDeleteDialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'SearchImage.dart';

class ItemAdd extends StatefulWidget {
  ItemModel item;
  bool isNew;

  ItemAdd({this.item, this.isNew});

  @override
  _ItemAddState createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  List<String> keyword = ['garbage'];
  File _image;
  final picker = ImagePicker();
  String _newID;
  bool _hasImage = false;
  bool _imageType = true; //true = network, false = file

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
      _imageType = false;
      _hasImage = true;
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

    var _name = widget.item.name;
    for (i = 0; i <= _name.length - 1; i++) {
      for (j = i + 1; j <= _name.length; j++) {
        keyword.add(_name.substring(i, j));
        print(_name.substring(i, j));
      }
    }
  }

  Future<void> addProduct() async {
    CollectionReference firestore = FirebaseFirestore.instance
        .collection('Store')
        .doc(context.read<Market>().marketNo)
        .collection('Product');

    var docID = widget.isNew ? _newID : widget.item.itemNo;

    if (_hasImage && !_imageType) {          //이미지가 있으면서, 이미지타입이 파일인경우
      String path = (widget.item.detail == null)
          ? (widget.item.name + '/normal.jpg')
          : widget.item.name + '/' + widget.item.detail + '.jpg';

      storage.ref(path).putFile(_image);
      await storage.ref(path).getDownloadURL().then((value) => widget.item.image = value);
    }

    if(!_hasImage){         //이미지가 없는 경우
      //No image 링크
      widget.item.image=
          'https://firebasestorage.googleapis.com/v0/b/capstone-43f20.appspot.com/o/No_image.png?alt=media&token=20af2af2-d931-4b08-813e-0e4e60fa053d';
    }

    return firestore
        .doc(docID)
        .set({
          'Name': widget.item.name,
          'Detail': widget.item.detail,
          'Price': widget.item.price,
          'Stock': widget.item.stock,
          'Image': widget.item.image,
          'Keyword': keyword
        })
        .then((value) => Navigator.of(context).pop())
        .catchError((error) => print("add Product Error"));
  }

  @override
  void initState() {
    CollectionReference firestore = FirebaseFirestore.instance
        .collection('Store')
        .doc(context.read<Market>().marketNo)
        .collection('Product');

    //상품 추가라면 문서번호 미리 생성하기
    if (widget.isNew)
      firestore.add({'Name': '임시상품'}).then((DocumentReference doc) {
        print("새로운 아이디 : ${doc.id}");

        setState(() {
          _newID = doc.id;
          _imageType = true;
          _hasImage = false;
        });
      }).catchError((onError) => print("new Product Error"));

    //상품 변경이라면, 텍스트 미리 채우기
    if (!widget.isNew) {
      controller[0].text = widget.item.name;
      controller[1].text = widget.item.detail;
      controller[2].text = widget.item.price.toString();
      controller[3].text = widget.item.stock.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        //뒤로가기 버튼을 눌러서 pop 못하게 막기!
        return Future(() => false);
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
                  Row(
                    children: [
                      !_hasImage
                          ? Container(
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black12, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              width: size.width * 0.5,
                              height: size.height * 0.3,
                              child: Center(
                                child: Icon(Icons.photo_camera, size: 20.0),
                              ),
                            )
                          : _imageType
                              ? Image.network(widget.item.image,
                                  width: size.width * 0.5,
                                  height: size.height * 0.3)
                              : Image.file(_image,
                                  width: size.width * 0.5,
                                  height: size.height * 0.3),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              String url = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SearchImage()));

                              print("URL is $url");

                              setState(() {
                                widget.item.image = url;
                                _imageType = true;
                                _hasImage = true;
                              });
                            },
                            child: Text(
                              "이미지 검색하기",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: getImage,
                            child: Text(
                              "내 디바이스에서 찾기",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
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
                            widget.item.name = controller[0].text;
                            widget.item.detail = controller[1].text;
                            widget.item.price = int.parse(controller[2].text);
                            widget.item.stock = int.parse(controller[3].text);

                            makeKeyword();
                          });

                          bool isAdd = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                var itemNo =
                                    widget.isNew ? _newID : widget.item.itemNo;
                                return ProductAddDialog(itemNo: itemNo);
                              });

                          if (isAdd) addProduct();
                        },
                        child: Text(
                          '등록',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          //미리 만들어둔 문서ID 삭제
                          if (widget.isNew) deleteProduct();

                          Navigator.of(context).pop();
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

                                if (isDelete) {
                                  deleteProduct();
                                  Navigator.of(context).pop();
                                }
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
    CollectionReference firestore = FirebaseFirestore.instance
        .collection('Store')
        .doc(context.read<Market>().marketNo)
        .collection('Product');

    if (widget.isNew) {
      return firestore
          .doc(_newID)
          .delete()
          .then((value) => print(
              "*************************Product Deleted ${widget.item.itemNo}"))
          .catchError((error) => print("Failed to delete user: $error"));
    } else {
      return firestore
          .doc(widget.item.itemNo)
          .delete()
          .then((value) => print(
              "*************************Product Deleted ${widget.item.itemNo}"))
          .catchError((error) => print("Failed to delete user: $error"));
    }
  }
}
