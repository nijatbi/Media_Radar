import 'package:flutter/material.dart';
import 'package:media_radar/views/Favourites/SelectedList.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:media_radar/views/accounts/Account.dart';
import 'package:media_radar/views/accounts/Profile.dart';

class RouteGenerator {
  static Route<dynamic> routeGenerator(RouteSettings settins) {
    switch (settins.name) {
      case '/login':
        return MaterialPageRoute(builder: (context)=>LoginPage());
      case '/account':
        return MaterialPageRoute(builder: (context)=>Account());
      case '/profile':
        return MaterialPageRoute(builder: (context)=>Profile());
      case '/selectedList':
        return MaterialPageRoute(builder: (context)=>SelectedList());
      default:
        return MaterialPageRoute(builder: (context)=>LoginPage());
    }
  }
}