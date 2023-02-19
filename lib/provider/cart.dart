import 'dart:ffi';

import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem({required this.id, required this.title, required this.price, required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem>  _item = {};

  Map<String, CartItem> get items{
    return {..._item};
  }


  double get totalAmount{
    double  total = 0;
    _item.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }
  int get itemCount {
    return _item.length;
  }
  void addItem(String id, double price, String title){

    if(_item.containsKey(id)){
      _item.update(id, (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1
      ));

    }else{
      _item.putIfAbsent(id, () => CartItem(id: id, title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  void Clear(){
    _item = {};
    notifyListeners();
  }

  void removeItem(String id){
    _item.remove(id);
    notifyListeners();
  }


}