import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../Services/product_dialog_service.dart';
import 'package:carousel_slider/carousel_controller.dart';

class ProductDialog extends StatelessWidget {
  final ProductDialogService _productDialogService = ProductDialogService();
  final String productId;
  final imageUrl = 'http://192.168.122.1:8000/storage/products/';

  ProductDialog({Key? key, required String this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto Selecionado'),
      ),
      body: FutureBuilder(
          future:
              _productDialogService.fetchProductDialog(productId: productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Nenhum produto carregado... ${snapshot.error}'),
              );
            } else if (snapshot.data != null) {
              final List<Map<String, dynamic>> productData = snapshot.data!;
              final product = productData.first;
              final List<String> cleanColors = (product['colors'] as String)
                  .replaceAll(RegExp(r'[^\w\s]+'), '')
                  .split(' ');
              final List<String> cleanSizes = (product['colors'] as String)
                  .replaceAll(RegExp(r'[^\w\s]+'), '')
                  .split(' ');
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                          ),
                          items: (product['images'] is List)
                              ? (product['images'] as List)
                                  .map<Widget>((image) {
                                  return Image.network(
                                    imageUrl +
                                        image.replaceAll(
                                            RegExp(r'[\[\]"]'), ''),
                                    fit: BoxFit.cover,
                                  );
                                }).toList()
                              : [
                                  Image.network(imageUrl +
                                      product['images']
                                          .replaceAll(RegExp(r'[\[\]"]'), ''))
                                ]),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors
                                        .yellow), // Ícone de estrela para representar avaliação
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star_half,
                                    color: Colors
                                        .yellow), // Ícone de estrela pela metade
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Preço: R\$ ${product['price']}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Qtd:  ${product['stock_quantity']}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'height: ${product['height']} x Width: ${product['width']} x Length: ${product['length']}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            if (cleanColors.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cores disponíveis:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 8.0,
                                    children: [
                                      for (var color in cleanColors)
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(
                                                    color.substring(1),
                                                    radix: 16) +
                                                0xFF000000),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            SizedBox(height: 8.0),
                            if (cleanSizes.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tamanhos Disponiveis:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Wrap(
                                    spacing: 8.0,
                                    children: [
                                      for (var size in cleanSizes)
                                        Chip(
                                          label: Text(size),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text('${product['description']}'),
                                SizedBox(height: 8.0),
                                ExpansionTile(
                                    title: Text('Comments'),
                                    children: [Text('${product['comments']}')]),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            } else {
              return Container(
                child: Text('nenhum produto carregado'),
              );
            }
          }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                print('Adicionar ao carrinho...');
              },
              child: Text('Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            TextButton(
              onPressed: () {
                print('Comprar produo...');
              },
             
              child: Text('buy product',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
