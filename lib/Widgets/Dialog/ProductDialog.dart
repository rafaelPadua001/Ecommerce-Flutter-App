import 'package:flutter/material.dart';
import '../../Services/product_dialog_service.dart';

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

             return ListView.builder(
              itemCount: productData.length,
              itemBuilder: (context, index) {
                final product = productData[index];
                print(product);
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (product.containsKey('images') && product['images'] is List)
                        for (var image in product['images'])
                          Image.network(
                            imageUrl + image,
                            fit: BoxFit.cover,
                          ),
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
                            Text(
                              '${product['description']}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 8.0),
                             if (product.containsKey('colors') && product['colors'] is List)
                              ListTile(
                                title: Text('Cores:'),
                                subtitle: Wrap(
                                  spacing: 8.0,
                                  children: [
                                    for (var color in product['colors'])
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                          ],
                        ),
                        
                      ),
                      
                    ],
                     
                  ),
                ),
                    ],
                  ),
                  );
              },
            );
            } else {
              return Container(
                child: Text('Merdaaaaaaa'),
              );
            }
          }),
    );
  }
}
