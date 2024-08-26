import 'package:ecommerce/core/configs/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> fetchLogin(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse(ApiConfig.baseURL + ApiConfig.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Simpan access_token ke dalam local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);

        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': response.reasonPhrase};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }
}
