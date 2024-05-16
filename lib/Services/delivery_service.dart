import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Services/api_service.dart';

class DeliveryService {
  Future<List<Map<String, dynamic>>> fetchDelivery() async {
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

  Future<List<Map<String, dynamic>>> calculate(request) async {
    try{
      final apiurl = '${ApiConfig.getApiBaseUrl()}/calculateDelivery';
     
      final response = await http.post(Uri.parse(apiurl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request),
        
      );

      if(response.statusCode == 200){
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((item) => item as Map<String, dynamic>).toList();
      }
      else{
        throw Exception('Failed to calculate delivery. Status code: ${response.statusCode}');
      }
    }
    catch(e){
       throw Exception('Error: $e');
    }
  }
}