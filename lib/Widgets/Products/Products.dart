import 'package:flutter/material.dart';
import '../../Services/products_service.dart';

class Products extends StatelessWidget {
  final Product products = Product();
  final baseUrl = 'http://192.168.122.1:8000/storage/products/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: products.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data != null) {
            return GridView.builder(
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Define o número de colunas na grade
                crossAxisSpacing: 10, // Espaçamento entre as colunas
                mainAxisSpacing: 8, // Espaçamento entre as linhas
                childAspectRatio: 1, // Define a proporção entre a largura e a altura dos itens
              ),
              shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final productData = snapshot.data![index];
                  final productImage =
                      productData['images'].replaceAll(RegExp(r'[\[\]"]'), '');
                  final imageUrl = baseUrl + productImage;
                  return InkWell(
                    onTap: (() => {
                          print('produto Escolhido ${productData['name']}'),
                        }),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 175, // Altura da imagem
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Text(
                              productData['name'],
                            )
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              productData['description'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Text('Nenhum produto encontrado');
          }
        });
  }
}
