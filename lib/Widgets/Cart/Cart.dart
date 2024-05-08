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
    try {
      final List<Map<String, dynamic>> cartProducts =
          await cartService.getCarts();

      double total = 0;
      for (final product in cartProducts) {
        final dynamic price = product['price'];
        if (price != null) {
          total += double.parse(price.toString());
        }
      }

      setState(() {
        totalPrice = total;
      });
    } catch (e) {
      print('Erro ao carregar os itens do carrinho: $e');
      // Tratar erro de carregamento do carrinho aqui
    }
  }

  Widget _buildBottomDelete(String productId) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          try {
            print('delete $productId');
            await cartService.deleteProduct(productId);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$productId removido com sucesso do carrinho.'),
            ));
            setState(() {
              _buildSumPrice();
            });
          } catch (e) {
            print('Erro ao excluir o produto: $e');
          }
        },
      ),
    );
  }

  Widget __buildProductImgs(dynamic images) {
    List<String> imageList = [];

    if (images is String) {
      images = images.replaceAll(RegExp(r'[\[\]"]'), '');
      imageList = images.split(',');
    } else if (images is List<String>) {
      imageList = List<String>.from(images);
    } else {
      return SizedBox();
    }

    if (imageList.isNotEmpty) {
      String firstImage = baseImageUrl + imageList.first.trim();
      return Image.network(
        firstImage,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildProductName(dynamic names) {
    List<String> nameList = [];

    if (names is String) {
      nameList.add(names);
    } else if (names is List<String>) {
      nameList = List<String>.from(names);
    } else {
      return Text('Formato de nomes não suportado');
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(names),
      ],
    );
  }

  Widget _buildProductPrice(dynamic prices) {
    List<String> priceList = [];
    if (prices is String) {
      priceList.add(prices);
    } else if (prices is List<String>) {
      priceList = List<String>.from(prices);
    } else {
      return SizedBox();
    }

    if (priceList.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: priceList.map((price) => Text(price)).toList(),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildColorCircles(dynamic colors) {
    List<String> colorList = [];

    if (colors is String) {
      colorList.add(colors);
    } else if (colors is List<dynamic>) {
      colorList = List<String>.from(colors);
    } else {
      return Text('Formato de cores não suportado');
    }

    return Row(
      children: colorList.map((color) {
        return Container(
          width: 24,
          height: 24,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Color(int.parse(color, radix: 16) + 0xFF000000),
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipSize(dynamic sizes) {
    List<String> sizeList = [];

    if (sizes is String) {
      sizeList.add(sizes);
    } else if (sizes is List<dynamic>) {
      sizeList = List<String>.from(sizes);
    } else {
      return Text('Formato de tamanho não suportado');
    }

    return Wrap(
      children: sizeList.map((size) {
        return Chip(
          label: Text(size),
          backgroundColor: Colors.grey[300],
          labelStyle: TextStyle(color: Colors.black),
        );
      }).toList(),
    );
  }

  Widget _buildListProduct(Map<String, dynamic> cartProduct) {
    final dynamic colors = cartProduct['colors'];
    final dynamic sizes = cartProduct['sizes'];

    final dynamic productName = cartProduct['name'];
    final dynamic productPrice = cartProduct['price'];
    final dynamic productImgs = cartProduct['images'];

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
                __buildProductImgs(productImgs),
                SizedBox(height: 8),
                _buildProductName(productName),
                _buildProductPrice(productPrice),
                _buildColorCircles(colors),
                SizedBox(height: 8),
                Text('Sizes:'),
                _buildChipSize(sizes),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        initialValue: cartProduct['quantity'].toString(),
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
