import 'package:capstone/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier{
  String userNo;
  String name;
  String phoneNum;
  String email;
  String addr;
  String postCode;
  String authState;

  UserModel({this.userNo, this.name, this.phoneNum, this.email, this.addr, this.postCode, this.authState});

  Future<void> readFromDB(String userNo) async {
    //파이어베이스 객체 초기화
    CollectionReference firebase =
    FirebaseFirestore.instance.collection('User');

    this.userNo = userNo;

    //파이어베이스에서 정보 읽어와 속성에 할당
    await firebase.doc(userNo).get().then((DocumentSnapshot document) {
      this.name = document.data()['Name'];
      this.phoneNum = document.data()['PhoneNum'];
      this.addr = document.data()['Addr'];
      this.email = document.data()['Email'];
      this.postCode = document.data()['PostCode'];
      this.authState = document.data()['AuthState'];
    });

    print("로드 완료입니당 :: ${this.name}");

    //값이 변했음을 알림
    notifyListeners();
    print("프롬디비 : 값이 변경됨을 알림");
  }

  Future<void> writeToDB() async{
    CollectionReference firestore =
    FirebaseFirestore.instance.collection('User');

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userNo', userNo);

    return firestore
        .doc(userNo)
        .set({
      'Name': name,
      'PhoneNum' : phoneNum,
      'Email' : email,
      'Addr': addr,
      'PostCode': postCode,
      'AuthState': authState
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Error"));



  }
}
