import 'package:http/http.dart' as http;
import 'dart:convert';

class Subcategory{
  Future<List<Map<String, dynamic>>> fetchSubcategories({required String categoryId}) async {
   final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/subcategories/$categoryId'));

    print(response);
    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((subcategory) => subcategory as Map<String, dynamic>).toList();
    }
    else{
      throw Exception('Falha ao carregar as subcategorias');
    }
  }
}

