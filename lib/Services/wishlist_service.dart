import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';

class WishlistService {
  final AuthService _authService = AuthService();

  Future<DatabaseReference> getDatabase() async {
    final databaseReference = FirebaseDatabase.instance.reference();

    return databaseReference;
  }

  Future<List<String>> getWishlist() async {
    try {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
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
          await FirebaseDatabase.instance.reference();
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

  Future<void> store(product) async {
    try {
      User? _authUser = await _authService.getCurrentUser();
      final DatabaseReference databaseReference = await getDatabase();

      databaseReference
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

  // Future<void> getCurrentLikes() async {

  // }
}
