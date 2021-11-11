import 'package:flutter_complete_guide/models/hcsProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/hcsProduct.dart';
import '../hcsProducts.dart';

// API manager class for the DataGovAPI.

class DataGovAPIManager {
  static Future<List<HcsProduct>> getProducts(String query) async {

    final validCharacters = RegExp(r'^[a-zA-Z0-9]'); //for checking valid input

    if(validCharacters.hasMatch(query) == false){
      print("enter a proper search first");
      return null;
    }

    String url =
        "https://data.gov.sg/api/action/datastore_search?resource_id=f60c8cea-7e1c-4dae-a550-2f6db43e0946&q=$query";
    int _itemCount = 0;
    print(query);
    print("inside apimanager");
    var jsonResponse;
    try {
      http.Response response = await http.get(url);
      
      if (response.statusCode == 200) {
        jsonResponse = convert.jsonDecode(response.body);

        List<dynamic> input = jsonResponse['result']['records'];
        List<HcsProduct> products = fetchProducts(input);
        print(products);
        print('see printed ^');
        return products;
      } else {
        // return List<Record>();
        return List<HcsProduct>();
      }
    } catch (error) {
      // return List<Record>();
      return List<HcsProduct>();
    }
  }
}
