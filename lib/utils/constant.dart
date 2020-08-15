import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:passio_manager/ui/authentication_screen.dart';
import 'package:passio_manager/ui/overview_filter_screen.dart';
import 'package:passio_manager/ui/overview_receipts_screen.dart';
import 'package:passio_manager/ui/overview_revenue_screen.dart';
import '../ui/home_screen.dart';
import '../ui/login_screen.dart';
import './custom_colors.dart';

// API constant
const String BASE_URL = 'https://passioreportapi.azurewebsites.net';
const String CHECK_LOGIN_API = 'api/users/login';
const String GET_USER_API = 'api/users';
const String GET_STORES_API = 'api/stores';
const String GET_DATE_REPORT_API = 'api/date-reports/by-date-interval';

const Map<String, String> UN_AUTHORIZE_HEADER = {
  'Content-Type': 'application/json; charset=UTF-8',
};

// Key to save data on disk
const String ACCESS_TOKEN_KEY = 'access_token';
const String STORE_ID_KEY = 'store_id';
// Type of data to save on disk
enum SavingType {
  String,
  Int,
  Bool,
  Double,
  StringList,
}

// Unit type
enum UnitType {
  vnd,
  order,
}

// Image path
const String BACKGROUND_IMAGE_PATH = 'assets/images/img_bg.jpg';
const String LOGO_IMAGE_PATH = 'assets/images/app_icon.png';
const String AVATAR_IMAGE_PATH = 'assets/images/avatarLogo.png';
const String FILTER_WHITE_ICON_PATH = 'assets/images/filter_white.png';
const String FILTER_ICON_PATH = 'assets/images/filter.png';
const String SHARE_WHITE_ICON_PATH = 'assets/images/share_white.png';
const String SHARE_ICON_PATH = 'assets/images/share.png';

// Request method
enum RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

// Color of chart
// At store == 0 => light_mustard
// Delivery == 1 => pastel_red
// Take away == 2 => dark_sky_blue
const List<Color> CHART_COLOR = [
  CustomColors.light_mustard,
  CustomColors.pastel_red,
  CustomColors.dark_sky_blue,
];

final Map<String, WidgetBuilder> listRoutes = {
  '/authentication': (BuildContext context) => AuthenticationPage(),
  '/home': (BuildContext context) => HomeScreen(),
  '/login': (BuildContext context) => LoginScreen(),
  '/overview_filter': (BuildContext context) => OverviewFilterScreen(),
  '/overview_revenue': (BuildContext context) => OverviewRevenueScreen(),
  '/overview_receipts': (BuildContext context) => OverviewReceiptsScreen(),
};
