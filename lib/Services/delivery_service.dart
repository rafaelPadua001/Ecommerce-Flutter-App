import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Services/api_service.dart';

class DeliveryService {
  Future<List<Map<String, dynamic>>> fetchQuotations() async {
    try{
      final apiUrl = '${ApiConfig.getApiBaseUrl()}/delivery';
      final response = await http.get(Uri.parse(apiUrl));
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);
        return data.map((quotation) => quotation as Map<String, dynamic>)
        .toList();
      }
      else{
        throw Exception('Nenhum quotation encontrado');
      }
    }
    catch(e){
      throw Exception('Error: ${e}');
    }
    

  }
}