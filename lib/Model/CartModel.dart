import 'package:flutter/cupertino.dart';
import '../Services/cart_service.dart';

class CartModel extends ChangeNotifier {
  List<Map<String, dynamic>>_items = [];
  
  final CartService _cartService = CartService();
  List<Map<String, dynamic>> get items => _items;

  CartModel(){
    getItems();
  }
  void getItems() async {
   try{
    _items = await _cartService.getCarts();
    notifyListeners();
   }
   catch(e){
    print('Failed to load cart items: $e');
   }
    
  }

  void addItem(Map<String, dynamic>? product) {
    if (product != null && product.containsKey('id')) {
   
      _items.add(product);

      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere(((item) => item['productId'] == productId));
    getItems();
    notifyListeners();
  }
}
