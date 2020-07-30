import 'package:flutter/material.dart';
import 'package:passio_manager/ui/select_store_screen.dart';
import '../ui/select_store_screen.dart';
import '../ui/home_screen.dart';
import '../ui/login_screen.dart';

final String baseUrl = 'https://passioreportapi.azurewebsites.net';
final String checkLoginApi = 'api/users/login';
final String getUserApi = 'api/users';
final String getStoresApi = 'api/stores';

final Map<String, String> unAuthorizeHeader = {
  'Content-Type': 'application/json; charset=UTF-8',
};

final String accessTokenKey = 'access_token';
final String storeIdKey = 'store_id';
final String backgroundImagePath = 'assets/images/img_bg.jpg';
final String logoImagePath = 'assets/images/app_icon.png';

enum SavingType {
  String,
  Int,
  Bool,
  Double,
  StringList,
}

enum RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}
final routes = {
  '/home': (BuildContext context) => HomeScreen(),
  '/login': (BuildContext context) => LoginScreen(),
  '/select_store': (BuildContext context) => SelectStoreScreen(),
};
