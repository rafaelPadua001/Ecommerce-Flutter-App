import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';

class LikesService {
  final AuthService _authService = AuthService();

 Future<DatabaseReference> getDatabase() async {
  final databaseReference = FirebaseDatabase.instance.reference();
  
  return databaseReference;
 } 

 Future<void> store(product) async {
  try{
     User? _authUser = await _authService.getCurrentUser();
     final DatabaseReference databaseReference = await getDatabase();
  
      databaseReference.child('wishlist').child(_authUser!.uid).set({
        'productId': product['id'],
        'productName': product['name'],
        'userId': _authUser.uid,
        'userName': _authUser.displayName,
      });
  }
  catch(e){
     throw Exception('É necessário estar logado para usar essa função? $e');
  }
 }
 
  // Future<void> getCurrentLikes() async {

  // }
}