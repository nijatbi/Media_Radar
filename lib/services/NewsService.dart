import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:media_radar/models/New.dart';
import 'package:http/http.dart' as http;
import 'package:media_radar/services/AuthService.dart';

import '../models/User.dart';
import 'SecureStorageService.dart';

class NewsService{
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
          .get(Uri.parse("${AuthService.baseUrl}/news/all_news_by_stream_keywords?start_date=${startDate}&end_date=${endDate}&page=${page}&is_grouped=${false}&is_selected=${false}"),
      headers: {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      },
      );
      if(response.statusCode==200){
        print(response.body);
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((e) => News.fromJson(e)).toList();
      }
      print(response.body);
      return [];
    }
  }
}