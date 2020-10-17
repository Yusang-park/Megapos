import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  User user;
  bool isSigned;
  String userNo; //UID
  String authState;

  Future<void> initUser() async {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      this.isSigned = true;
      this.userNo = user.uid;
      readFromDB(userNo);
    } else {
      isSigned = false;
    }
  }

  // updateUser() { 인자로 필요한 변수 입력받아야함
  //   writeToDB();
  // }

  setUser(User user, {String authState}) {
    this.user = user;
    this.userNo = user.uid;
    this.authState = authState ?? 'Customer';
    isSigned = true;
    readFromDB(userNo);

    notifyListeners();
  }

  delUser() {
    this.user = null;
    isSigned = false;
    notifyListeners();
  }

  Future<void> readFromDB(String userNo) async {
    //파이어베이스 객체 초기화
    CollectionReference firebase =
        FirebaseFirestore.instance.collection('User');

    this.userNo = userNo;

    try {
      //파이어베이스에서 정보 읽어와 속성에 할당
      await firebase.doc(userNo).get().then((DocumentSnapshot document) {
        this.authState = document.data()['AuthState'];
      });
    } catch (e) {
      await writeToDB();
    }
    //값이 변했음을 알림
    notifyListeners();
  }

  Future<void> writeToDB() async {
    CollectionReference firestore =
        FirebaseFirestore.instance.collection('User');

    return firestore
        .doc(userNo)
        .set({'AuthState': authState})
        .then((value) => print("User Added"))
        .catchError((error) => print("Error"));
  }
}
