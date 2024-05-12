import 'package:flutter/cupertino.dart';

class CartModel extends ChangeNotifier {
  List<String> _items = [];
  List<String> get items => _items;

  void addItem(Map<String, dynamic>? product) {
    print('Novo Produto: ${product}');
    if (product != null && product.containsKey('id')) {
      print(product['id']);
      _items.add(product['id'].toString());

      notifyListeners();
    }
  }

  void removeItem(Map<String, dynamic> cartProduct) {
    _items.remove(cartProduct['productId'].toString());
    notifyListeners();
  }
}
