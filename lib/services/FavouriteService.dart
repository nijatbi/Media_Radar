import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';

import '../models/New.dart';

class FavouriteService{
  static Future<bool> addNewsToFavService(String ?id)async{
    final token=await SecureStorageService.getToken();
    if(token==null) {return false;}
    final response=await http.post(Uri.parse("${AuthService.baseUrl}/news/add_favorite"),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    },
      body: jsonEncode({
        "id":id
      })
    );
    if(response.statusCode==200){
      print("${response.body}");
      return true;
    }else{
      return false;
    }
  }
  static Future<List<News>> getNewsFromMain() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/news/favorites"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final dynamic jsonData = jsonDecode(decodedBody);
        print("Favourite Main:${jsonData}");
        if (jsonData is List) {
          return jsonData.map((e) {
            try {
              return News.fromJson(e as Map<String, dynamic>);
            } catch (error) {
              print("Tək bir xəbər parsinqində xəta: $error");
              return null;
            }
          })
              .whereType<News>()
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("FavouriteService xətası: $e");
      return [];
    }
  }
  static Future<List<News>> getNewsFromTelegram() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/tg/get_favourites_for_user"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final dynamic jsonData = jsonDecode(decodedBody);
        print("Favourite Main:${jsonData}");
        if (jsonData is List) {
          return jsonData.map((e) {
            try {
              return News.fromTelegramJson(e as Map<String, dynamic>);
            } catch (error) {
              print("Tək bir xəbər parsinqində xəta: $error");
              return null;
            }
          })
              .whereType<News>()
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("FavouriteService xətası: $e");
      return [];
    }
  }
}