import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';


class SubcategoryProductService {
  Future<List<Map<String, dynamic>>> fetchSubcategoryProduct({required String subcategoryId}) async {
     final String api_url = '${ApiConfig.getApiBaseUrl()}/products/subcategory/${subcategoryId}';
    final response = await http.get(Uri.parse(api_url));

    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((subcategoryProducts) => subcategoryProducts as Map<String, dynamic>).toList();
    }
    else{
      throw Exception('Falha ao carregar subcategorias de produtos');
    }
  }

}