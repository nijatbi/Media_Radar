import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import '../models/User.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;
  User? user;

  Future<void> getCurrentUser() async {
    isLoading = true;

    try {
      final token = await SecureStorageService.getToken();

      if (token == null) {
        isLoggedIn = false;
        isLoading = false;
        notifyListeners();
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
}
