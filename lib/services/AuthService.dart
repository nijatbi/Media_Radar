import 'package:http/http.dart' as http;

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
}
