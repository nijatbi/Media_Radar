import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import '../models/New.dart';

class FavouriteService {
  // 1. Ana xəbərləri favorita əlavə etmək
  static Future<bool> addNewsToFavService(int? id) async {
    final token = await SecureStorageService.getToken();
    if (token == null || id == null) return false;
    final response = await http.post(
      Uri.parse("${AuthService.baseUrl}/news/add_favorite"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode({"id": id}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Xeta : ${response.body}');
      return false;
    }
  }

  // 2. Ana xəbərləri favoritdən silmək
  static Future<bool> deleteNewsFromMain(int? id) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || id == null) return false;
      final url = Uri.parse("${AuthService.baseUrl}/news/favorites/$id");
      final response = await http.delete(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("Server xətası (${response.statusCode}): ${response.body}");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // 3. Ana xəbərlərin favorit siyahısını çəkmək
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
        if (jsonData is List) {
          return jsonData.map((e) {
            try {
              return News.fromJson(e as Map<String, dynamic>);
            } catch (error) {
              return null;
            }
          }).whereType<News>().toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 4. Telegram favorit siyahısını çəkmək
  static Future<List<News>> getNewsFromTelegram() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];
      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/tg/get_favourites_for_user"),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final dynamic jsonData = jsonDecode(decodedBody);
        if (jsonData is List) {
          return jsonData.map((e) {
            try {
              return News.fromTelegramJson(e as Map<String, dynamic>);
            } catch (error) {
              return null;
            }
          }).whereType<News>().toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 5. Telegram xəbərini favorita əlavə etmək (DÜZƏLDİLDİ: toString() əlavə edildi)
  static Future<bool> addNewsToFavTelegramService(int? channelId, int? postId) async {
    final token = await SecureStorageService.getToken();
    if (token == null || channelId == null || postId == null) return false;

    // BURADA channelId və postId-ni .toString() etdik ki, 'int' xətası verməsin
    final url = Uri.parse("${AuthService.baseUrl}/tg/add_favourite_post_or_reply").replace(
      queryParameters: {
        "source_id": channelId.toString(),
        "pr_id": postId.toString(),
        "is_post": "true",
      },
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 6. Telegram xəbərini favoritdən silmək (DÜZƏLDİLDİ: URL formatı təkmilləşdirildi)
  static Future<bool> deleteNewsFromTelegram(int? channelId, int? postId) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || channelId == null || postId == null) return false;

      // Manuel string birləşdirmə yerinə daha etibarlı olan .replace istifadə etdik
      final url = Uri.parse("${AuthService.baseUrl}/tg/delete_favourite").replace(
        queryParameters: {
          "source_id": channelId.toString(),
          "pr_id": postId.toString(),
        },
      );

      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("xeta bas verdi:${response.body}");
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}