import 'package:flutter/material.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:media_radar/views/accounts/Account.dart';

class RouteGenerator {
  static Route<dynamic> routeGenerator(RouteSettings settins) {
    switch (settins.name) {
      case '/login':
        return MaterialPageRoute(builder: (context)=>LoginPage());
      case '/account':
        return MaterialPageRoute(builder: (context)=>Account());
      default:
        return MaterialPageRoute(builder: (context)=>LoginPage());
    }
  }
}