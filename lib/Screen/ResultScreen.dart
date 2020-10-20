import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  bool getIsSuccessed(Map<String, String> ResultScreen) {
    if (ResultScreen['imp_success'] == 'true') {
      return true;
    }
    if (ResultScreen['success'] == 'true') {
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    Map<String, String> ResultScreen =
        ModalRoute.of(context).settings.arguments;
    bool isSuccessed = getIsSuccessed(ResultScreen);

    Timer.periodic(Duration(seconds: 3), (timer){
      timer.cancel();
      Navigator.pop(context);
    });


    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: new AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('결제 내역'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isSuccessed ? '결제에 성공하였습니다' : '결제에 실패하였습니다',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                  color: Colors.white
              ),
            ),
            Text(
              '결제 내역 페이지로 이동합니다',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
