import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductApi {
  static const String _url = 'https://dummyjson.com/products';

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final data = jsonDecode(response.body);

    return List<Map<String, dynamic>>.from(data['products']);
  }
}