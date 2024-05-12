import 'package:flutter/cupertino.dart';


class CartModel extends ChangeNotifier{
  
  List<String> _items = [];
  List<String> get items => _items;

  void addItem(){
    _items.add('Product');

    notifyListeners();
  }
}