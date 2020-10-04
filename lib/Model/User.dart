import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userNo;
  String name;
  String phoneNum;
  String email;
  String addr;
  String postCode;

  UserModel(String userNo) {
    CollectionReference firebase =
        FirebaseFirestore.instance.collection('User');
    this.userNo = userNo;
    firebase.doc(userNo).get().then((DocumentSnapshot document) {
      this.name = document.data()['Name'];
      this.phoneNum = document.data()['phoneNum'];
      this.addr = document.data()['addr'];
      this.email = document.data()['email'];
      this.postCode = document.data()['postCode'];
      //this.image = 'assets/images/' + itemNo.toString() + '.jpg';
    });
  }
}
