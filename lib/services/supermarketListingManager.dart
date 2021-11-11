import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/supermarket_listing.dart';

// API manager class for the Supermarket scraping API.

class SupermarketServices{

  static Future<List<SupermarketListing>> getListing(String query) async{
    print(query);
    String url = "https://jonlee1923.pythonanywhere.com/?query=$query";

    int _itemCount = 0; 
    var jsonResponse;     
    try{
      http.Response response = await http.get(url);
      if(response.statusCode == 200){
        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        _itemCount = jsonResponse.length;
        
    
        final List<SupermarketListing> listings = supermarketListingFromJson(response.body);
    
        print(listings);
   
        return listings;
      }
      else{
        return List<SupermarketListing>();
      }
    }catch (error){
      return List<SupermarketListing>();
    }
  }
}