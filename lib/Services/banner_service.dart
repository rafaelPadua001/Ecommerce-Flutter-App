import 'package:http/http.dart' as http;
import 'dart:convert';

class BannerService{
  Future<List<Map<String, dynamic>>> fetchBanners() async {
    final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/banner'));

    if(response.statusCode == 200){
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
    //  return data.map((banner) => banner as Map<String, dynamic>).toList();
      return [data];
    }
    else
    {
      return throw  Exception('Erro ao carregar banners');
    }
    

  }
}