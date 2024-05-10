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

  Future<List<Map<String, dynamic>>> fetchProductDialog(
      {required String productId}) async {
    final String api_url = '${ApiConfig.getApiBaseUrl()}/product/${productId}';

    final response = await http.get(Uri.parse(api_url));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data = [json.decode(response.body)];
      return data;
    } else {
      throw Exception('Nenhum produto encontrado');
    }
  }

   Future <List<Map<String, dynamic>>> getCarts() async {
    try{
      final _authUser = await _authService.getCurrentUser();
      if (_authUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final databaseReference = await getDatabase();
      DatabaseEvent event =
          await databaseReference.child('cart').child(_authUser.uid).once();
      DataSnapshot snapshot = event.snapshot;
      List<Map<String, dynamic>> cart = []; 

      if(snapshot.value != null){
        Map<String,dynamic> cartData = Map<String, dynamic>.from(snapshot.value as Map<Object?, Object?>);
        cartData.forEach((key, value) {
          cart.add({
            'id': key,
            'name': value['name'],
            'price': value['price'],
            'quantity': value['quantity'],
            'colors': value['colors'],
            'sizes': value['sizes'],
            'productId': value['productId'],
            'images': value['images'],
            'userId': value['userId'],
            
          });
        });
      }

      return cart;

    }
    catch(e){throw Exception('Error: ${e}');}
  }


 Future<void> store(Map<String, dynamic>? product) async {
    try {
      User? _authUser = await _authService.getCurrentUser();
      final DatabaseReference databaseReference = await getDatabase();

      await databaseReference
          .child('cart')
          .child(_authUser!.uid)
         // .child(product!['id'].toString())
          .push()
          .set({
        'productId': product!['id'],
        'userId': _authUser.uid,
        'user_name': _authUser.displayName,
        'name': product['name'],
        'description': product['description'],
        'quantity': 1,
        //'discount_id': product['discount_id'],
        'price': product['price'],
        'colors': product['colors'],
        'sizes': product['sizes'],
        'images': product['images'],
      });

      countProductCart();
    } catch (e) {
      throw Exception('É necessario estar logado para realizar essa ação $e');
    }
  }


  Future<int> countProductCart() async {
    try {
      final _authUser = await _authService.getCurrentUser();
      if (_authUser == null) {
        throw Exception('usuario não autenticado');
      }

      final databaseReference = await getDatabase();
      final DataSnapshot dataSnapshot =
          (await databaseReference.child('cart').child(_authUser.uid).once())
              .snapshot;

      final dynamic cartData = dataSnapshot.value;
      int productCount = 0;

      if (cartData != null && cartData is List) {
        for (var item in cartData) {
          if (item is Map && item.containsKey('productId')) {
            productCount++;
          }
        }
      }

      print('Usuario possui $productCount itens em seu carrinho');

      return productCount;
    } catch (e) {
      throw Exception('Erro ao carregar lista de produtos no carrinho $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final _authUser = await _authService.getCurrentUser();
    if (_authUser == null) {
      throw Exception('usuario não autenticado');
    }

    final databaseReference = await getDatabase();
    await databaseReference
        .child('cart')
        .child(_authUser.uid)
        .child(productId)
        .remove()
        .then((_) {
      print('Produto removido do carrinho');
    }).catchError((error) {
      return Future.error(error);
    });
  }
}
