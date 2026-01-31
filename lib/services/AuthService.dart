import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SecureStorageService.dart';

class AuthService {
  static const String baseUrl = 'https://dev-api.mediaradar.io';

  static Future<String> login(String userName, String password) async {
    final Map<String, String> body = {
      'grant_type': '',
      'username': userName,
      'password': password,
      'scope': '',
      'client_id': '',
      'client_secret': '',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('SUCCESS: ${response.body}');
      return response.body;
    } else {
      print('ERROR ${response.statusCode}: ${response.body}');
      return response.body;
    }
  }

 static Future<bool> activateStream(List<int> idList) async {
    try {
      final auth_token = await SecureStorageService.getToken();

      if (auth_token == null || auth_token.isEmpty) {
        print('Token yoxdur, giriş edilməyib.');
        return false;
      }

      final response = await http.patch(
        Uri.parse("$baseUrl/streams/activate_stream"),
        headers: {
          'Authorization': "Bearer $auth_token",
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(idList),
      );

      if (response.statusCode == 200) {
        print("Uğurla icra olundu: ${response.body}");
        return true;
      } else {
        print("Xəta baş verdi (${response.statusCode}): ${response.body}");
        return false;

      }
    } catch (e) {
      print("İstisna (Exception): $e");
      throw Exception("Xəta: $e");
    }
  }

  static Future<bool> deActivateStream(List<int> idList) async {
    try {
      final auth_token = await SecureStorageService.getToken();

      if (auth_token == null || auth_token.isEmpty) {
        print('Token yoxdur, giriş edilməyib.');
        return false;
      }

      final response = await http.patch(
        Uri.parse("$baseUrl/streams/deactivate_stream"),
        headers: {
          'Authorization': "Bearer $auth_token",
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(idList),
      );

      if (response.statusCode == 200) {
        print("Uğurla icra olundu: ${response.body}");
        return true;
      } else {
        print("Xəta baş verdi (${response.statusCode}): ${response.body}");
        return false;

      }
    } catch (e) {
      print("İstisna (Exception): $e");
      throw Exception("Xəta: $e");
    }
  }

  static Future<bool> deleteStream(int? streamId)async{
    try {
      final auth_token = await SecureStorageService.getToken();

      if (auth_token == null || auth_token.isEmpty) {
        print('Token yoxdur, giriş edilməyib.');
        return false;
      }
      final response=await http.delete(Uri.parse("${AuthService.baseUrl}/streams/delete_stream?stream_id=${streamId}"),
      headers: {
        'Authorization': "Bearer $auth_token",
        'Accept': 'application/json',
      }
      );
      if(response.statusCode==200){
        print("Stream silindi");
        return true;
      }
      else{
        print("Silinende xeta :${response.body}");
        return false;
      }
    }
    catch (e){
      throw Exception("${e}");
    }


  }


}