import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';

class ProductDialogService {
  final AuthService _authService = AuthService();
  Future<DatabaseReference> getDatabase() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    return databaseReference;
  }

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

  Future<void> store(Map<String, dynamic>? product) async {
    try{
      User? _authUser = await _authService.getCurrentUser();
      final DatabaseReference databaseReference = await getDatabase();

      await databaseReference
      .child('cart')
      .child(_authUser!.uid)
      .child(product!['id'].toString())
      .set({
        'productId': product['id'],
        'name': product['name']
      });
     

    }
    catch(e){
      throw Exception('É necessario estar logado para realizar essa ação $e');
    }
    print('Produto selecionado $product');
  }
}