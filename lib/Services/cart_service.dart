import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';

class CartService {
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

  Future<List<String>> getCarts() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.child('cart').once();
    DataSnapshot snapshot = event.snapshot;

    List<String> carts = [];

    if(snapshot.value != null){
      Map<dynamic, dynamic> values = snapshot.value as Map<String, dynamic>;

      values.forEach((key, value) {
        carts.add(value['cart']);
      });
    }
      return carts;
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
        'userId': _authUser.uid,
        'user_name': _authUser.displayName,
        'name': product['name'],
        'quantity': 1,
        'colors': product['colors'],
        'sizes': product['sizes'],
        'images': product['images'],
      });
     
      countProductCart();
    }
    catch(e){
      throw Exception('É necessario estar logado para realizar essa ação $e');
    }
  }

  Future<int> countProductCart() async {
    try{
      final _authUser = await _authService.getCurrentUser();
      if(_authUser == null){
        throw Exception('usuario não autenticado');
      }
      
      final databaseReference = await getDatabase();
      final DataSnapshot dataSnapshot = (await databaseReference
      .child('cart')
      .child(_authUser.uid)
      .once()).snapshot;

      final dynamic cartData = dataSnapshot.value;
      int productCount = 0;

      if(cartData != null && cartData is List){
        for(var item in cartData){
          if(item is Map && item.containsKey('productId')){
            productCount++;
          }
        }
      }

      print('Usuario possui $productCount itens em seu carrinho');
      
      return productCount;
    }
    catch(e){
      throw Exception('Erro ao carregar lista de produtos no carrinho $e');
    }
  }
}