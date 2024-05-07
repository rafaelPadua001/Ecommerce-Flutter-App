import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  double totalPrice = 0;
  @override
  void initState() {
    super.initState();
    _buildSumPrice();
  }

  Future<void> _buildSumPrice() async {
    final List<Map<String, dynamic>> cartProduct = await cartService.getCarts();

    double total = 0;
    for (final product in cartProduct) {
      final dynamic price = product['price'];
      if (price != null) {
        total += double.parse(price.toString());
      }
    }

    setState(() {
      totalPrice = total;
    });
  }

  Widget _buildBottomDelete(String productId) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          print('delete ${productId}');
          await cartService.deleteProduct(productId);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${productId} removido com sucesso do carrinho.'),
          ));
          setState(() {});
        },
      ),
    );
  }

  Widget _buildListProduct(Map<String, dynamic> cartProduct) {
    final dynamic images = cartProduct['images'];

    String firstImageUrl = '';

    if (images != null && images.isNotEmpty) {
      if (images is String) {
        final List<String> imageList = images.split(',');
        if (imageList.isNotEmpty) {
          final String productImage =
              imageList.first.trim().replaceAll(RegExp(r'[\[\]"]'), '');
          if (productImage.isNotEmpty) {
            firstImageUrl = baseImageUrl + productImage;
          }
        }
      } else if (images is List<String> && images.isNotEmpty) {
        final String productImage =
            images.first.trim().replaceAll(RegExp(r'[\[\]"]'), '');
        if (productImage.isNotEmpty) {
          firstImageUrl = baseImageUrl + productImage;
        }
      }
    }

    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                if (firstImageUrl
                    .isNotEmpty) // Verifique se firstImageUrl não está vazio antes de exibir a imagem
                  Image.network(
                    firstImageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey, // Placeholder de imagem
                  ),
                SizedBox(height: 8),
                Text(cartProduct['name'] ?? 'Product Name Not Available'),
                Text('R\$' +
                    (cartProduct['price']?.toString() ??
                        'Price Not Available')),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        initialValue: cartProduct['quantity']?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                        ),
                        onChanged: (value) {
                          // print(value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildBottomDelete(cartProduct['productId'].toString()),
              ],
            ),
          ),
        ),
      ],
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
              'Erro ao carregar os itens do carrinho: ${snapshot.error}',
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: [
              Text(
                'Total: R\$ ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final cartProduct = snapshot.data![index];
                    return _buildListProduct(cartProduct);
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text('Nenhum produto encontrado'),
          );
        }
      },
    );
  }
}
