import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String itemNo;
  String name;
  String detail;
  int price;
  int stock;
  String image;


  void setItemNo(String itemNo){
    this.itemNo = itemNo;
  }

  ItemModel({
      this.itemNo, this.name, this.detail, this.price, this.stock, this.image});

  ItemModel.fromDB(String itemNo, String marketNo) {
    this.itemNo = itemNo;

    CollectionReference firebase = FirebaseFirestore.instance
        .collection('Store')
        .doc(marketNo)
        .collection('Product');
    firebase.doc(itemNo).get().then((DocumentSnapshot document) {
      this.name = document.data()['Name'];
      this.detail = document.data()['Detail'];
      this.price = document.data()['Price'];
      this.stock = document.data()['Stock'];
      this.image = document.data()['Image'];
    });
  }
}

//
//  //DB에서 아이템 객체 생성성
//  Item.loadDB(String itemNo){
//    CollectionReference item = FirebaseFirestore.instance.collection('Product');
//
//    item.doc(itemNo).get().then((DocumentSnapshot document){
//      itemNo = itemNo;
//      name = document.data()['Name'];
//      price = document.data()['Price'];
//      stock = document.data()['Stock'];
//      image = 'assetes/images/' + itemNo.toString() + '.jpg';

//    });
//  }

//관리자 - 상품 추가(DB업로드), 제거, 변경 메서드 만들기
