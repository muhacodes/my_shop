// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ExceptionErrors/httpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
   String? _token;
   DateTime? _expiryDate;
   String? _userId;
   Timer? _authTimer;

  static const apiKey = "AIzaSyB4GcF9dCQzLE4fp6aRR_P7eDDt8r0gEcY";

   String? get userId {
     return _userId;
   }

  bool get isAuth{
    if(token == null){
      return false;

    }else{
      return true;
    }
  }
  String? get token{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token!;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String action) async {

    try{
      var url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$action?key=$apiKey');
      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true,
      }));
      final responseData = json.decode(response.body);
      if(json.decode(response.body)['error'] != null){
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogout();
      notifyListeners();
      final storage = await SharedPreferences.getInstance();
      Map<String, dynamic> userData = {
        'userId' : _userId,
        'token' : _token,
        'expiryDate' : _expiryDate!.toIso8601String(),
      };
      final encodeUserData = json.encode(userData);
      storage.setString('userData', encodeUserData);

    }catch(e){
     throw e.toString();
    }


  }


  Future<void> signUp(String email ,  String password) async{
    return _authenticate(email, password, 'signUp');
  }


  Future<void> login(String email, String password) async{
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
     _token = null;
     _expiryDate = null;
     _userId = null;
     if(_authTimer != null){
       _authTimer!.cancel();
       _authTimer = null;

     }
     final storage = await SharedPreferences.getInstance();
     storage.clear();
     notifyListeners();
  }
  void _autoLogout(){
     print("expiry Date is $_expiryDate");
     print("current time is ${DateTime.now()}");
     if(_authTimer != null){
       _authTimer?.cancel();
     }
     final expiryTime = _expiryDate!.difference(DateTime.now()).inSeconds;

     _authTimer = Timer(Duration(seconds: expiryTime), () => logout(),);
  }

  Future<bool> autoLogin() async{
     final storage = await SharedPreferences.getInstance();
     if(storage.containsKey('userData')){
       final userData = storage.getString('userData');
       final data = json.decode(userData!);
       final expiryDate = DateTime.parse(data['expiryDate']);
       print(expiryDate);
       print(DateTime.now());
       if(expiryDate.isAfter(DateTime.now())){

         _userId = data['userId'];
         _token = data['token'];

         _expiryDate = data['expiryDate'];
         notifyListeners();

         _autoLogout();


         return false;
       }else{
       }
     }
     return false;

  }

   Future<bool> tryAutoLogin() async {
     final prefs = await SharedPreferences.getInstance();
     if (!prefs.containsKey('userData')) {
       return false;
     }

     final userData = prefs.getString('userData');
     final extractedUserData = json.decode(userData!);
     // final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
     final expiryDate = DateTime.parse(extractedUserData!['expiryDate']);

     if (expiryDate.isBefore(DateTime.now())) {
       return false;
     }
     _token = extractedUserData['token'];
     _userId = extractedUserData['userId'];
     _expiryDate = expiryDate;
     notifyListeners();
     _autoLogout();
     return true;
   }


}