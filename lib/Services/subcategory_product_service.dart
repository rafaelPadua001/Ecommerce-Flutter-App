import 'package:http/http.dart' as http;
import 'dart:convert';

class SubcategoryProductService {
  Future<List<Map<String, dynamic>>> fetchSubcategoryProduct({required String subcategoryId}) async {
    final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/products/subcategory/${subcategoryId}'));

    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((subcategoryProducts) => subcategoryProducts as Map<String, dynamic>).toList();
    }
    else{
      throw Exception('Falha ao carregar subcategorias de produtos');
    }
  }

}