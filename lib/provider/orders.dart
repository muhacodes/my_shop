import 'dart:convert';

import 'cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.datetime
  });
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken;
  final  String userId;

  List<OrderItem> get items{
    return [..._orders];
  }


  Orders(this.authToken, this.userId, this._orders);
  var _first_time_loading_orders = true;



  Future<bool?> getOrders()async {
    var url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    print('getOrders method fired');
      try{
        final response = await http.get(url);
        if(response.body == 'null'){
          return null;
        }
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<OrderItem> _loadedOrders = [];
        data.forEach((key, value) {
          _loadedOrders.add(
              OrderItem(
                  id: key,
                  amount: value['amount'],
                  datetime: DateTime.parse(value['datetime']),
                  products: (value['products'] as List<dynamic>)
                      .map((order) => CartItem(
                      title:  order['title'],
                      quantity: order['quantity'],
                      price: order['price'],
                      id: order['id']
                  )).toList()
              )
          );
        });

        _orders = _loadedOrders.reversed.toList();
        notifyListeners();
        return true;
      }catch(e){
        print(e.toString());
        print('error');
      }
      return false;

  }

  Future<int> addOrder(List<CartItem> cartProducts, double total) async{
    var url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
      final _timeStamp = DateTime.now();
      var response = await http.post(url, body: json.encode({
        'amount' : total,
        'products':
          cartProducts.map((item) => {
            'id': item.id,
            'title' : item.title,
            'quantity' : item.quantity,
            'price' : item.price
          }).toList()
        ,
        'datetime' : _timeStamp.toIso8601String(),
      }));
      String orderId =  json.decode(response.body)['name'];
      if(response.statusCode == 200){
        _orders.insert(0, OrderItem(
          id: orderId,
          amount: total,
          products: cartProducts,
          datetime: _timeStamp,
        ));
        notifyListeners();
      }
      return response.statusCode;
      
  }
}