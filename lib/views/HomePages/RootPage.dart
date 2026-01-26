import 'package:flutter/material.dart';
import 'package:media_radar/providers/AuthProvider.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:media_radar/views/HomePages/HomePage.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getCurrentUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.isLoggedIn) {

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.isLoggedIn) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
