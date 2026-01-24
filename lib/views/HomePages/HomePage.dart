import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/views/Favourites/SelectedList.dart';
import 'package:media_radar/views/HomePages/HomeContent.dart';
import 'package:media_radar/views/accounts/Account.dart';
import 'package:media_radar/views/accounts/Profile.dart';
import 'package:media_radar/views/dailies/Daily.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    HomeContent(),
    Daily(),
    SelectedList(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Constant.baseColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30,fontWeight: FontWeight.w400,),
                label: 'Ana səhifə',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: 'Gündəm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Seçilmişlər',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Parametrlər',
              ),
            ],
          ),
        ),


      ),
    );
  }
}




