import 'package:flutter/cupertino.dart';

class CartModel extends ChangeNotifier {
  List<String> _items = [];
  List<String> get items => _items;

  void addItem(Map<String, dynamic>? product) {
    if (product != null && product.containsKey('id')) {
   
      _items.add(product['id'].toString());

      notifyListeners();
    }
  }

  void removeItem(Map<String, dynamic> cartProduct) {
    _items.remove(cartProduct['productId'].toString());
    notifyListeners();
  }
}
