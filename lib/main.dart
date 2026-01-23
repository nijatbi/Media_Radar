import 'package:flutter/material.dart';
import 'package:media_radar/routes.dart';
import 'package:media_radar/views/Favourites/SelectedList.dart';
import 'package:media_radar/views/HomePages/HomePage.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:media_radar/views/accounts/Account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Radar',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      onGenerateRoute: RouteGenerator.routeGenerator,

    );
  }
}

