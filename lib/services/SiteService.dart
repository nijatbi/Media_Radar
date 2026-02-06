import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:media_radar/models/New.dart';
import 'package:media_radar/models/TelegramChannel.dart';
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
class SiteService{
  static Future<List<String>> getAllSitesNews() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/news/all_sites"),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
        jsonDecode(response.body);

        final List<dynamic> sites = decoded['sites'];

        return sites.map((e) => e.toString()).toList();
      }

      return [];
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<TelegramChannel>> getAllSitesTelegram() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}/tg/all_channels"),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map((item) => TelegramChannel.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      print("API Xətası: $e");
      return [];
    }
  }

  static Future<List<News>> getNewsFromSearchTelegram({
    List<String>? keywords,
    String? startTime,
    String? endTime,
    int page = 1,
    List<int>? sourcesIds,
  }) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return [];

      String url = "${AuthService.baseUrl}/tg/search_all_sources?page=$page";

      if (startTime != null && startTime.isNotEmpty) url += "&start_date=$startTime";
      if (endTime != null && endTime.isNotEmpty) url += "&end_date=$endTime";

      url += "&match_all=false&ascending=false";

      final Map<String, dynamic> requestBody = {
        "keywords": keywords,
        "sources": sourcesIds,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("Telegram axtarış body: $requestBody");
      print("Telegram axtarış Status: ${response.statusCode}");
      print("Telegram axtarış Cavab: ${response.body}");

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((e) => News.fromTelegramJson(e)).toList();
        }
        else if (jsonData is Map) {
          final List<dynamic> newsList = jsonData['data'] ?? jsonData['results'] ?? jsonData['news'] ?? [];
          return newsList.map((e) => News.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print("Xəta detalı: $e");
      return [];
    }
  }
}