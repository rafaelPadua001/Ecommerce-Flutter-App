import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
class ProductDialogService {

  Future<List<Map<String, dynamic>>> fetchProductDialog({required String productId}) async {
    final String api_url = '${ApiConfig.getApiBaseUrl()}/product/${productId}';
   
    final response = await http.get(Uri.parse(api_url));

    if(response.statusCode == 200){
      List<Map<String, dynamic>> data = [json.decode(response.body)];
      return data;
    }
    else{
      throw Exception('Nenhum produto encontrado');
    }
  }
}