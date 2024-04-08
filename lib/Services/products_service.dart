import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/products'));

    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((product) => product as Map<String, dynamic>).toList();
    }
    else{
      throw new Exception('Falha ao carregar os produtos');
    }
  }
}
