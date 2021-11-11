import 'package:flutter/material.dart';

//Entity class for HCS products.
class HcsProduct{
    HcsProduct({
        @required this.productName,
        @required this.packageSize,
        this.isFavorite = false,
        this.id,
        this.imageUrl,
    });

    String productName;
    String packageSize;
    bool isFavorite;
    String id;
    String imageUrl;

    bool toggleFavoriteStatus(){
      isFavorite = !isFavorite;
      return isFavorite;
    }
}

