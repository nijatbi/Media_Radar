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

  static Future<String> RegisterInit(String? email) async {
    try {
      final response = await http.post(
          Uri.parse("${AuthService.baseUrl}/register/init"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "email": email
          })
      );

      if (response.statusCode == 200) {
        print("Sorgu:${response.body}");
        return '';
      } else {
        print("Xəta kodu: ${response.statusCode}");
        print("Xəta body: ${response.body}");
        return response.body;
      }
    } catch (e) {
      print("Exception: $e");
      return jsonEncode({"error": "Bağlantı xətası baş verdi"});
    }
  }


  static Future<String> checkOtp(String?email,String? otpCode)async{
    try {
      final response=await http.post(Uri.parse("${AuthService.baseUrl}/register/check_otp"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },body: jsonEncode({
            "email": email,
            "otp_code":otpCode
          })
      );
      if(response.statusCode==200){
        print("ugurlu check otp :${response.body}");
      return '';
      }
      else{
        print("${response.body}");
        return response.body;
      }
    }
    catch (e){
      throw Exception("Exception :${e}");

    }
  }

  static Future<String> registerProfile(String? userName, String? name, String? email, String? surname, String pass) async {
    try {
      // 1. Ünvanı Swagger-də olduğu kimi SLASH-SIZ yazırıq
      final url = Uri.parse("https://dev-api.mediaradar.io/register/final");

      // 2. Standart post əvəzinə Client yaradırıq (Redirect-i idarə etmək üçün)
      var client = http.Client();
      var request = http.Request('POST', url);

      // 3. Header-ləri Swagger/Curl ilə eyniləşdiririk
      request.headers.addAll({
        'accept': 'application/json',
        'Content-Type': 'application/json',
        // Bəzi serverlər User-Agent olmayanda redirect verir
        'User-Agent': 'Mozilla/5.0',
      });

      request.body = jsonEncode({
        "email": email?.trim(),
        "username": userName?.trim(),
        "name": name?.trim(),
        "surname": surname?.trim(),
        "password": pass
      });

      request.followRedirects = false;

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 307) {
        return "";
      } else {
        return response.body;
      }
    } catch (e) {
      print("Xəta: $e");
      return "Xəta: $e";
    }
  }

}