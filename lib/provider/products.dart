import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../ExceptionErrors/httpException.dart';

class Products with ChangeNotifier{
  var fetched = false;
  List<Product> _items = [];

  final String AuthToken;
  final String userId;
  Products(this.AuthToken, this.userId, this._items);

  // var _Favorites = false;

  List<Product> get favoriteItems{
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Product> get items{

    return [..._items];
  }


  // void showFavorites(){
  //   _Favorites = true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _Favorites = false;
  //   notifyListeners();
  // }
  Future<void> getProducts([bool filterd = false]) async{
    String filter = filterd ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$AuthToken&$filter ');
    var response = await http.get(url);
    final data = json.decode(response.body) as Map;
    List<Product> loadedProducts = [];
    url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$AuthToken');

    response = await http.get(url);
    final favorite =  json.decode(response.body);
    data.forEach((key, value) {
      loadedProducts.add(
        Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favorite[key] ?? false,
        )
      );
    });
    _items = loadedProducts;
    notifyListeners();
    // fetched = true;
  }

  Future<void> addProducts(Product product) async{
    String id = await apiProductsAdd(product);
    final createProduct = Product(
      id: id,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      title: product.title,
    );

    _items.add(createProduct);
    notifyListeners();

  }
  Product getProduct(id){
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct)async{

    final  url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$AuthToken');
    final response = await http.patch(url, body: json.encode({
      'title' : newProduct.title,
      'description': newProduct.description,
      'price' : newProduct.price,
      'imageUrl': newProduct.imageUrl,
      'userId' : userId,
    }));


    final productIndex =  _items.indexWhere((item) => item.id == id);
    if(productIndex >= 0){
     _items[productIndex] = newProduct;
     notifyListeners();
    }else{
     print('soemthing went wrong');
    }

  }


  Future<String> apiProductsAdd(Product newproduct)async {
    var url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$AuthToken');

    var response = await http.post(url, body: json.encode({
      'title' : newproduct.title,
      'description': newproduct.description,
      'imageUrl' : newproduct.imageUrl,
      'price' : newproduct.price,
      'userId' : userId,
    }));
    return json.decode(response.body)['name'];

  }
  Future<void> deleteProduct(id) async{
    var url = Uri.parse('https://ukashshop-d6c1b-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$AuthToken');
    var productIndex = _items.indexWhere((item) => item.id == id);
    Product? product = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >= 400){
      _items.insert(productIndex, product);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    product = null;
  }


}