import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Market with ChangeNotifier {
  String marketNo;

  String name;
  String address;
  String ceo;
  String contact;

  Market({this.name, this.marketNo, this.address, this.ceo, this.contact});

  Future<void> readFromDB(String marketNo) async {
    //파이어베이스 객체 초기화
    CollectionReference firebase =
        FirebaseFirestore.instance.collection('Store');

    this.marketNo = marketNo;

    //파이어베이스에서 정보 읽어와 속성에 할당
    await firebase.doc(marketNo).get().then((DocumentSnapshot document) {
      this.name = document.data()["Name"];
      this.address = document.data()["Address"];
      this.ceo = document.data()["CEO"];
      this.contact = document.data()["Contact"];
    });

    print("로드 완료입니당 :: ${this.name}");

    //값이 변했음을 알림
    notifyListeners();
    print("프롬디비 : 값이 변경됨을 알림");
  }

  Future<void> writeToDB() {
    CollectionReference firestore =
        FirebaseFirestore.instance.collection('Store');

    List<String> keyword = [];
    int i, j;

    for (i = 0; i <= name.length - 1; i++) {
      for (j = i + 1; j <= name.length; j++) {
        keyword.add(name.substring(i, j));
        print(name.substring(i, j));
      }
    }

    return firestore
        .doc(marketNo)
        .set({
          'Keyword': keyword,
          'Name': name,
          'Address': address,
          'CEO': ceo,
          'Contact': contact
        })
        .then((value) => print("Market Added"))
        .catchError((error) => print("Error"));
  }
}
