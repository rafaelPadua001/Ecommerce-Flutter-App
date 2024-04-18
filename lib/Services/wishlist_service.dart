import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';

class WishlistService {
  final AuthService _authService = AuthService();

  Future<DatabaseReference> getDatabase() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    return databaseReference;
  }

  Future<List<String>> getWishlist() async {
    try {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();
      DatabaseEvent event = await databaseReference.child('wishlist').once();
      DataSnapshot snapshot = event.snapshot;

      List<String> likes = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          likes.add(value['like']);
        });
      }
      return likes;
    } catch (e) {
      throw Exception('Error : ${e}');
    }
  }

  Future<bool> getProductWishlist(int productId) async {
    try {
      final User? _authUser = await _authService.getCurrentUser();
      if (_authUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final DatabaseReference databaseReference =
          await FirebaseDatabase.instance.ref();
      DatabaseEvent event = await databaseReference
          .child('wishlist')
          .child(_authUser!.uid)
          .child(productId.toString())
          .once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        return values['isFavorite'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

Future<int> countProductsWishlist() async {
  try {
    final User? _authUser = await _authService.getCurrentUser();
    if (_authUser == null) {
      throw Exception('Usuário não autenticado');
    }

    final DatabaseReference databaseReference = await getDatabase();
    final DataSnapshot dataSnapshot = (await databaseReference
        .child('wishlist')
        .child(_authUser.uid)
        .once()).snapshot;

     
    final dynamic wishlistData = dataSnapshot.value;
    int productCount = 0;

    if (wishlistData != null && wishlistData is List) {
      for (var item in wishlistData) {
        if (item is Map && item.containsKey('productId')) {
          productCount++;
        }
      }
    }

    print('O usuário ${_authUser.uid} possui $productCount na lista de desejos');
    return productCount;
  } catch (e) {
    throw Exception('Erro ao carregar lista de desejos: $e');
  }
}

  Future<void> store(product) async {
    try {
      User? _authUser = await _authService.getCurrentUser();
      final DatabaseReference databaseReference = await getDatabase();

      await databaseReference
          .child('wishlist')
          .child(_authUser!.uid)
          .child(product['id'].toString())
          .set({
        'productId': product['id'],
        'productName': product['name'],
        'userId': _authUser.uid,
        'userName': _authUser.displayName,
        'isFavorite': true,
      });
    } catch (e) {
      throw Exception('É necessário estar logado para usar essa função? $e');
    }
  }

  Future<void> destroy(String productId) async {
    try {
      final User? _authUser = await _authService.getCurrentUser();
      if (_authUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final DatabaseReference databaseReference = await getDatabase();
      await databaseReference
          .child('wishlist')
          .child(_authUser.uid)
          .child(productId)
          .remove()
          .then((_){
            print('Produto removido com sucesso da wishlist');
            return;
          })
          .catchError((error){
           return Future.error(error);
          });

      
    } catch (e) {
      throw Exception('Erro ao remover o produto da wishlist: $e');
    }
  }
}
