import 'package:http/http.dart' as http;
import 'dart:convert';

class Category {
  
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/categories'));

    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((category) => category as Map<String, dynamic>).toList();
    }
    else{
      throw Exception('Falha ao carregar as categorias');
    }
  }
}