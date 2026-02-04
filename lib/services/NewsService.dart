import 'dart:convert';
import 'package:media_radar/models/New.dart';
import 'package:http/http.dart' as http;
import 'package:media_radar/services/AuthService.dart';
import 'SecureStorageService.dart';

class NewsService{

  static Future<List<News>> getUserByTelegram({
    String? startDate,
    String? endDate,
    int page = 1,
}) async{
    final token=await SecureStorageService.getToken();
    if(token==null) {
      return [];
    }
    else{
      final response=await
      http
          .get(Uri.parse("${AuthService.baseUrl}/tg/post_and_replies_by_keywords?start_date=${startDate}&end_date=${endDate}&page=${page}&show_chosen=${false}"),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if(response.statusCode==200){
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<News> newsList = jsonData.map((e) => News.fromTelegramJson(e)).toList();
        return newsList;
      }
      return [];
    }
  }

  static Future<List<News>> getUserByStream({
    String? startDate,
    String? endDate,
    int page = 1,
  })async{

    final token=await SecureStorageService.getToken();
    if(token==null) {
      return [];
    }
    else{
      final response=await
      http
          .get(Uri.parse("${AuthService.baseUrl}/news/all_news_by_stream_keywords?start_date=${startDate}&end_date=${endDate}&page=${page}&is_grouped=${true}&is_selected=${false}"),
      headers: {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      },
      );
      if(response.statusCode==200){
        final List<dynamic> jsonData = jsonDecode(response.body);
        final result=jsonData.map((e) => News.fromJson(e)).toList();
        return result;
      }
      return [];
    }
  }

  static buildImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    return "${AuthService.baseUrl}/tg/get_image_by_filename?filename=${Uri.encodeComponent(path)}";
  }

  static Future<List<News>> getSimiliarsNews(int id) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/news/find_similar_news_by_id?id_=$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          return jsonData.map((e) => News.fromJson(e as Map<String, dynamic>)).toList();
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          return (jsonData['data'] as List).map((e) => News.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print("Servis xətası: $e");
      return [];
    }
  }

}