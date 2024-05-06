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

  Widget _buildBottomDelete(String productId){
    return Container(
            width: 40,
            height: 40,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                print('delete ${productId}');
                await cartService.deleteProduct(productId);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${productId} removido com sucesso do carrinho.'),));
                setState((){
                  
                }); 
              },
            ),
          );
  }
Widget _buildListProduct(Map<String, dynamic> cart_product) {
  dynamic images = cart_product['images'];
  String firstImageUrl = '';

  if (images != null) {
    if (images is String) {
      List<String> imageList = images.split(',');
      if (imageList.isNotEmpty) {
        String productImage = imageList[0].trim().replaceAll(RegExp(r'[\[\]"]'), '');
        if (productImage.isNotEmpty) {
          firstImageUrl = baseImageUrl + productImage;
        }
      }
    } else if (images is List && images.isNotEmpty) {
      String productImage = images[0].toString().trim().replaceAll(RegExp(r'[\[\]"]'), '');
      if (productImage.isNotEmpty) {
        firstImageUrl = baseImageUrl + productImage;
      }
    }
  }

  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          firstImageUrl.isNotEmpty
              ? Image.network(
                  firstImageUrl ?? '',
                  width: 100, // Ajuste o tamanho conforme necessário
                  height: 100, // Ajuste o tamanho conforme necessário
                  fit: BoxFit.cover,
                )
              : Container(width: 100, height: 100), // Placeholder de imagem
          SizedBox(height: 8,),
          Text(cart_product['name'] ?? 'Product Name Not Available'),
          Text('R\$' + (cart_product['price'] ?? 'Price Not Available')),
          SizedBox(height: 8),
          //Text('Quantity: ${cart_product['quantity']}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  initialValue: cart_product['quantity']?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                  onChanged: (value){
                    // print(value);
                  }
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          _buildBottomDelete(cart_product['productId'].toString()),
        ],
      ),
    ),
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
