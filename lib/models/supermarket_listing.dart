import 'dart:convert';
import 'package:flutter/material.dart';

//Entity class for supermarket listings.


List<SupermarketListing> supermarketListingFromJson(String str) =>
    List<SupermarketListing>.from(
        json.decode(str).map((x) => SupermarketListing.fromJson(x)));

String supermarketListingToJson(List<SupermarketListing> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class SupermarketListing {
  String brand;
  String imageurl;
  double price;
  String product;
  String redirectUrl;
  String supermarket;
  String id;

  SupermarketListing(
      {@required this.brand,
      @required this.imageurl,
      @required this.price,
      @required this.product,
      @required this.redirectUrl,
      @required this.supermarket,
      this.id});

  SupermarketListing.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    imageurl = json['imageurl'];
    price = double.parse(json['price'].substring(1));
    product = json['product'];
    redirectUrl = json['redirectUrl'];
    supermarket = json['supermarket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    data['imageurl'] = this.imageurl;
    data['price'] = this.price;
    data['product'] = this.product;
    data['redirectUrl'] = this.redirectUrl;
    data['supermarket'] = this.supermarket;
    
  }
}
