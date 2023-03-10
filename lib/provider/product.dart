import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });


  Future<int> toggleFavoriteStatus(String token, String userId) async {
    final  url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    final _oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await  http.put(url, body: json.encode(
      isFavorite
    ));
    if(response.statusCode >= 400){
      isFavorite = _oldStatus;
      notifyListeners();
    }
    return response.statusCode;

  }
  // void toggleFavoriteStatus () => isFavorite = !isFavorite;

}