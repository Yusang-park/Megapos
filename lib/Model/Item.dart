import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String itemNo;
  String name;
  String price;
  String stock;
  String image;


  //DB에서 아이템 객체 생성성
  Item.fromDB(String itemNo){
    CollectionReference item = FirebaseFirestore.instance.collection('Product');

    item.doc(itemNo).get().then((DocumentSnapshot document){
      itemNo = itemNo;
      name = document.data()['Name'];
      price = document.data()['Price'];
      stock = document.data()['Stock'];
      image = 'assetes/images/' + itemNo.toString() + '.jpg';
    });
  }



  //관리자 - 상품 추가(DB업로드), 제거, 변경 메서드 만들기



}