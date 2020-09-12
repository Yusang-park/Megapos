import 'dart:async';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:flutter/material.dart';

import 'Item.dart';

class SelectedItem {
  ItemModel item;
  int count;
  int sumPrice;

  SelectedItem(String itemNo) {
    item = ItemModel(itemNo);
    count = 1;
    print(item.itemNo + "번 아이템 클래스 생성");
  }

//
//  void plusCount(){
//    int stock = int.parse(item.stock);
//    if(stock > count) {
//      count++;
//      sumPrice = stock * count;
//    }
//  }
//
//  void minusCount(){
//    if(count > 0) {
//      count--;
//      sumPrice = int.parse(item.price) * count;
//    }
//  }
//
}
