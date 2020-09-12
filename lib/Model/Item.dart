import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String itemNo;
  String name;
  int price;
  int stock;
  String image;

  ItemModel(String itemNo) {
    CollectionReference firebase =
        FirebaseFirestore.instance.collection('Product');
    this.itemNo = itemNo;
    firebase.doc(itemNo).get().then((DocumentSnapshot document) {
      this.name = document.data()['Name'];

      this.price = document.data()['Price'];
      this.stock = document.data()['Stock'];
      this.image = 'assets/images/' + itemNo.toString() + '.jpg';
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
