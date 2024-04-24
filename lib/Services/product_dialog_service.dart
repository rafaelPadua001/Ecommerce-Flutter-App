import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDialogService {

  Future<List<Map<String, dynamic>>> fetchProductDialog({required String productId}) async {
    final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/product/${productId}'));

    if(response.statusCode == 200){
      List<Map<String, dynamic>> data = [json.decode(response.body)];
      return data;
    }
    else{
      throw Exception('Nenhum produto encontrado');
    }
  }
}