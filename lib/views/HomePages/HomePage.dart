import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.grid_view, color: Colors.black),
              onPressed: () {},
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {},
              ),
            ),

          ],
        )
      ),
    );
  }
}
