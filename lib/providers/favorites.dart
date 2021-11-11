import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/hcsProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Class to handle a users favorites. Part of a observer pattern.

class Favorites with ChangeNotifier {
  String authToken;
  String userId;
  List<HcsProduct> _favorites = [];

  Favorites(this.authToken, this.userId, this._favorites);
  // Favorites(this.authToken, this.userId);

  set setToken(String token) {
    authToken = token;
  }

  set setUserId(String id) {
    userId = id;
  }

  bool _check = true;
  bool _deleted = false;

  bool get checker {
    print(_check);
    return _check;
  }

  bool get checkDelete {
    return _deleted;
  }

  List<HcsProduct> get items {
    return [..._favorites];
  }

  Future<void> fetchAndSetFavs() async {
    print('checking in favourites');
    print(userId);
    print(authToken);

    final url = Uri.parse(
      'https://cz2006-ada0a-default-rtdb.asia-southeast1.firebasedatabase.app/favourites/$userId.json?auth=$authToken',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<HcsProduct> loadedProducts = [];
      extractedData.forEach((id, fav) {
        //we want to convert data into product objects based on product class
        loadedProducts.add(HcsProduct(
          productName: fav['productName'],
          packageSize: fav['packageSize'],
          isFavorite: fav['isFavorite'],
          imageUrl: fav['imageUrl'],
          id: id,
        ));
      });
      _favorites = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(HcsProduct product, String imageUrl) async {
    for (int i = 0; i < _favorites.length; i++) {
      if (_favorites[i].productName == product.productName) {
        _check = false;
        print('cant add');
        notifyListeners();
        return;
      }
    }

    _check = true;

    // print('checking');
    final url = Uri.parse(
        'https://cz2006-ada0a-default-rtdb.asia-southeast1.firebasedatabase.app/favourites/$userId.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'productName': product.productName,
          'packageSize': product.packageSize,
          'isFavorite': true,
          'imageUrl': imageUrl,
        }),
      );

      HcsProduct newProduct = HcsProduct(
        productName: product.productName,
        packageSize: product.packageSize,
        isFavorite: true,
        id: json.decode(response.body)[
            'name'], //uses the auto generated id from firebase for the products id
        imageUrl: imageUrl,
      );

      _favorites.add(
        newProduct,
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String productName) async {
    String id;
    _favorites.forEach((fav) {
      if (fav.productName == productName) {
        id = fav.id;
      }
    });

    final url = Uri.parse(
        'https://cz2006-ada0a-default-rtdb.asia-southeast1.firebasedatabase.app/favourites/$userId/$id.json?auth=$authToken');

    final existingFavIndex = _favorites.indexWhere((fav) => fav.id == id);
    var existingFav = _favorites[existingFavIndex];
    print('deleting');

    _favorites.removeAt(existingFavIndex);
    _deleted = true;
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _favorites.insert(existingFavIndex, existingFav); //undoing the delete
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingFav = null;
  }
}
