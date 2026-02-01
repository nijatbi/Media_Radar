import 'package:flutter/material.dart';
import 'package:media_radar/views/Favourites/SelectedList.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:media_radar/views/RegisterAndLogin/Register.dart';
import 'package:media_radar/views/accounts/Account.dart';
import 'package:media_radar/views/accounts/Profile.dart';
import 'package:media_radar/views/dailies/NewsItem.dart';

class RouteGenerator {
  static Route<dynamic> routeGenerator(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (context) => const Register());
      case '/account':
        return MaterialPageRoute(builder: (context) => const Account());
      case '/profile':
        return MaterialPageRoute(builder: (context) => const Profile());
      case '/categoryAndKey':
        return MaterialPageRoute(builder: (context) => const Profile());
      case '/selectedList':
        return MaterialPageRoute(builder: (context) => const SelectedList());

      case '/newsItem':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => NewsItem(
              id: args['id'] as int,
              date: args['date'] as String,
            ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}