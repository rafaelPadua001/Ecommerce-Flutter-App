import 'package:flutter/material.dart';
import '../../Services/cart_service.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartService cartService = CartService();
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cartService.getCarts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Text('Nenhum produto encontrado');
          }
        });
  }
}
