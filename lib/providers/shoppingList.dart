import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/supermarket_listing.dart';
import 'package:http/http.dart' as http;


//Class to handle a users shopping list. Part of a observer pattern.

class ShoppingList with ChangeNotifier {
  final String authToken;
  final String userId;

  List<SupermarketListing> _cart = [];

  ShoppingList(this.authToken, this.userId, this._cart);


  bool _check = true;
  bool get checker {
    print(_check);
    return _check;
  }
  
  List<SupermarketListing> get items {
    return [..._cart];
  }

  Future<void> fetchAndSetCart() async {
    final url = Uri.parse(
      'https://cz2006-ada0a-default-rtdb.asia-southeast1.firebasedatabase.app/shoppingList/$userId.json?auth=$authToken',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<SupermarketListing> cart = [];
      extractedData.forEach((id, item) {
        //we want to convert data into product objects based on product class
        cart.add(SupermarketListing(

          supermarket: item['supermarket'],
          brand: item['brand'],
          imageurl: item['imageurl'],
          product: item['product'],
          price: item['price'],
          redirectUrl: item['redirectUrl'],
          id: id,
        ));
      });
      _cart = cart;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addListing(SupermarketListing product) async {
    for (int i = 0; i < _cart.length; i++) {
      if (_cart[i].product == product.product) {
        _check = false;
        //print('cant add');
        notifyListeners();
        return;
      }
    }

    final url = Uri.parse(
        'https://cz2006-ada0a-default-rtdb.asia-southeast1.firebasedatabase.app/shoppingList/$userId.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'imageurl': product.imageurl,
          'price': product.price,
          'product': product.product,
          'redirectUrl': product.redirectUrl,
        }),
      );

      SupermarketListing newProduct = SupermarketListing(
        supermarket: product.supermarket,
        brand: product.brand,
        imageurl: product.imageurl,
        price: product.price,
        product: product.product,
        redirectUrl: product.redirectUrl,
        id: json.decode(response.body)['name'],
      );

      _cart.add(
        newProduct,
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteListing(String product) async{
    String id;
    _cart.forEach((item){
      if(item.product == product){
        id = item.id;
      }
    });

    final url = Uri.parse('https://cz2006-ada0a-default-rtdb.asia-southeast1.firebasedatabase.app/shoppingList/$userId/$id.json?auth=$authToken');

    final existingCartIndex = _cart.indexWhere((item) => item.id == id);
    var existingItem = _cart[existingCartIndex]; 

    _cart.removeAt(existingCartIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _cart.insert(existingCartIndex, existingItem); //undoing the delete
      notifyListeners();
      throw HttpException('Could not delete cart item');
    }

    print(_cart);
    notifyListeners();
  }
}
