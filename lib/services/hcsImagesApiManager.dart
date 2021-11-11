import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/images.dart';


// API manager class for the Google Image scraping API (For HCS products).

class HcsImagesApiManager{

  static Future<List<Images>> getImages(String query) async{
    final validCharacters = RegExp(r'^[a-zA-Z0-9]'); //for checking valid input

    if(validCharacters.hasMatch(query) == false){
      return null;
    }
    String url = "https://jonlee1923.pythonanywhere.com/image/?query=$query";

    int _itemCount = 0; 
    var jsonResponse;     
    try{
      http.Response response = await http.get(url);
      if(response.statusCode == 200){
        jsonResponse = jsonDecode(response.body);
        
        final List<Images> images = imagesFromJson(response.body);
        
        return images;
      }
      else{
        return List<Images>();
      }
    }catch (error){
      return List<Images>();
    }
  }
}