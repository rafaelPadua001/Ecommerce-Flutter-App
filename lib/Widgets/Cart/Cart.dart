import 'package:flutter/material.dart';
import '../../Services/cart_service.dart';
import '../../Services/api_service.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartService cartService = CartService();
  final ApiConfig_apiService = ApiConfig();
  final baseImageUrl = '${ApiConfig.getApiBaseUrl()}/storage/products/';

  Widget _buildListProduct(Map<String, dynamic> cart_product) {
    dynamic images = cart_product['images'];
    String firstImageUrl = '';

    final productImage =
        images.split(',')[0].trim().replaceAll(RegExp(r'[\[\]"]'), '');
   
    if (productImage is List && images.isNotEmpty) {
      String firstImage = productImage.toString();
      firstImageUrl = baseImageUrl + firstImage;
    } else if (images is String) {
      firstImageUrl = baseImageUrl + productImage.toString();
      
    }
    //final imageUrl = baseImageUrl + productImage;
    // print(imageUrl);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
      title: Text(cart_product['name']),
      subtitle: Text('Quantity: ${cart_product['quantity']}'),
      leading:
          firstImageUrl.isNotEmpty ? Image.network(firstImageUrl,  width: 60, height: 60, fit: BoxFit.cover) : SizedBox(),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cartService.getCarts(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Nenhum carrinho de compras encontrado  ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cart_product = snapshot.data![index];
                // Aqui você pode criar uma ListTile para cada item do carrinho

                return _buildListProduct(cart_product);
              },
            );
          } else {
            return Text('Nenhum produto encontrado');
          }
        });
  }
}
