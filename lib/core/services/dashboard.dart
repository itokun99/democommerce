import 'dart:convert';
import 'package:ecommerce/core/configs/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  Future<List<dynamic>> getProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No access token found.");
      }

      final response = await http.get(
        Uri.parse(ApiConfig.baseURL + ApiConfig.productsEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch products: ${response.reasonPhrase}");
      }

      return json.decode(response.body) as List<dynamic>;
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}
