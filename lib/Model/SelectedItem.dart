import 'dart:async';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:capstone/Widget/BasketTile.dart';
import 'package:flutter/material.dart';

import 'Item.dart';

class SelectedItem {
  ItemModel item;
  int count;
  int sumPrice;

  SelectedItem(String itemNo, String marketNo) {
    item = ItemModel.fromDB(itemNo, marketNo);
    sumPrice = 0;
    count = 0;
  }

  void plusCount() {
    int stock = item.stock;
    if (stock > count) {
      count++;
      sumPrice = stock * count;
    }
  }

  void minusCount() {
    if (count > 0) {
      count--;
      sumPrice = item.price * count;
    }
  }
}
