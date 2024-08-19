import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<void> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://your-api.com/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String token = data['access'];
      await storage.write(key: 'jwt_token', value: token);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
}
