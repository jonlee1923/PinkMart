import 'dart:convert';
import 'dart:async'; //allows us to use timer code

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../http_exception.dart';


//Class for user authentication. Part of a observer pattern.

class Auth with ChangeNotifier {
  //changenotifier mixin added so that we can call notify listeners to make sure that all places in the UI depending on the auth logic here is updated
  String
      _token; //token needed to attach to requests that reach endpoints that do need authentication
  //the token expires after some time
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer; //to handle ongoing timers etc

  bool get isAuth {
    //METHOD FOR TOKEN VALIDATION
    //if a token exists and has not expired then user is authenticated
    return token != null;
    //return true when it is not null
    //return false when null, means unauthenticated
  }

  String get token {
    if (_expiryDate != null && //if null then we dont have a valid token
        _expiryDate.isAfter(DateTime
            .now()) && //if the expiry date is in the future then it is valid
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCn0HNDXOJE8k-hRwp3q1i8Vxu4O_H_Pn8');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode(response.body));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        //checking if a error exists then we know we have a problem
        throw HttpException(responseData['error']
            ['message']); //throw error to show the user via auth screen
      }

      //log user in and store token

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData[
              'expiresIn']), //the response returns only tells us the duration(in seconds, in string) before the token expires
        ),
      );
      print(_token);
      print(_userId);
      _autoLogout();
      notifyListeners(); //to trigger consumer in main, to tell what homescreen to display
      //start of setting up shared preferences
      final prefs = await SharedPreferences
          .getInstance(); //this returns a future which will return
      //a future which eventually returns a shared preferences instance
      final userData = json.encode(//use json.encode to convert a map into string for storing
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        },
      );
      prefs.setString('userData', userData);//thus the string converted above is stored here in preferences and can be retrieved later
      //so the line above basically does something like this -> 'userData': stored user data    
    } catch (error) {
      throw error;
    }
  }

  //method that signs the user up
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  //method that logs in user
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {//returns true if a token is found and false otherwise
    final prefs = await SharedPreferences.getInstance();//access sharedPreferences
    if(!prefs.containsKey('userData')){
      return false; //returns false if no data stored on the user data key
      //and this return false value will automatically be wrapped in a future cuz of the async keyword
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;//extracting the map if it exists. Object values cuz we have different types there
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);//datetime.parse works because of the format we stored the datetime, earlier above
    if(expiryDate.isBefore(DateTime.now())){
      return false;//expiry date is in the past so just return
    }
    //initialise all the values cuz we have valid token, so that we can auto log in
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();//to set the timer again
    return true;//because we need to have a future which returns a boolean, false when auto login fails and true otherwise
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    //clear all data in shared preferences to make sure that any data that was in there is gone and not getting and not getting used in the auto login afterwards
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');//remove the key we wanna remove
    prefs.clear();//since we only store user data there it is fine to clear everything
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel(); //if a there is a existing timer already, cancel it
    }
    final timeToExpiry = _expiryDate
        .difference(DateTime.now())
        .inSeconds; //gives time to expiry in seconds
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
