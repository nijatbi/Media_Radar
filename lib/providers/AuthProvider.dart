import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:media_radar/models/Keyword.dart';
import 'package:media_radar/models/Stream.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;
  User? user;
  String token='';
  Future<void> getCurrentUser() async {
    isLoading = true;

    try {
      final token = await SecureStorageService.getToken();
      if (token == null) {
        isLoggedIn = false;
        isLoading = false;
        notifyListeners();
        MaterialPageRoute(builder: (_)=>LoginPage());
        return;
      }

      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/user/get_current_user"),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        user = User.fromJson(data);
        notifyListeners();

        isLoggedIn = true;
        notifyListeners();
      } else {
        isLoggedIn = false;
        user = null;
        if (kDebugMode) {
          print(
              "getCurrentUser error ${response.statusCode}: ${response.body}");
        }
      }
    } catch (e) {
      isLoggedIn = false;
      user = null;
      if (kDebugMode) print("getCurrentUser exception: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SecureStorageService.deleteToken();
    user = null;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> addStreamToUser(String streamName, List<String> keywords, BuildContext context) async {
    final auth_token = await SecureStorageService.getToken();

    if (auth_token == null || auth_token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token mövcud deyil')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${AuthService.baseUrl}/streams/create_stream"),
        headers: {
          'Authorization': "Bearer $auth_token",
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "stream_name": streamName,
          "keywords": keywords,
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        String newStreamName = "Yeni Stream";
        if (data['msg'] != null) {
          final match = RegExp(r'"(.+?)"').firstMatch(data['msg']);
          if (match != null) {
            newStreamName = match.group(1)!;
          }
        }

        final newStream = MediaStream(
          is_active: true,
          name: newStreamName,
          keywords: keywords.map((k) => Keyword(value: k)).toList(),
        );

        if (user != null) {
          user!.streams!.add(newStream);
          notifyListeners();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stream uğurla yaradıldı')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xəta: $e')),
      );
    }
  }

  Future<void> activateStream(int?id,NewsProvider newsProvider)async{
    try{
      final auth_token = await SecureStorageService.getToken();

      if (auth_token == null || auth_token.isEmpty) {
        print('Token yoxdur');
      }
      final response=await http.post(Uri.parse("${AuthService.baseUrl}/streams/deactivate_stream"),
      headers: {
        'Authorization': "Bearer $auth_token",
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },body: {
          id
          }
      );
    }
  }

}
