import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';

class Category {
  
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final String api_url = '${ApiConfig.getApiBaseUrl()}/categories';
    final response = await http.get(Uri.parse(api_url));

    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((category) => category as Map<String, dynamic>).toList();
    }
    else{
      throw Exception('Falha ao carregar as categorias');
    }
  }
}