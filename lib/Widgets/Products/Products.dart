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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Launch',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Define o número de colunas na grade
                      crossAxisSpacing: 10, // Espaçamento entre as colunas
                      mainAxisSpacing: 8, // Espaçamento entre as linhas
                      childAspectRatio:
                          0.65, // Define a proporção entre a largura e a altura dos itens
                    ),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final productData = snapshot.data![index];
                      final productImage = productData['images']
                          .replaceAll(RegExp(r'[\[\]"]'), '');
                      final imageUrl = baseUrl + productImage;
                      if (productData['launch'] == 1) {
                        return InkWell(
                          onTap: (() => {
                                print(
                                    'produto Escolhido ${productData['name']}'),
                              }),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Product added on your wishlist ${productData['id']}')));
                                      },
                                      child: Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 185,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Chip(
                                                      label: Text(
                                                        'R\$ ${productData['price']}',
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ]),
                                        ),
                                        ListTile(
                                          title: Text(productData['name']),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors
                                                    .yellow), // Ícone de estrela para representar avaliação
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star_half,
                                                color: Colors
                                                    .yellow), // Ícone de estrela pela metade
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child:
                                              Text(productData['description']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Highlight',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.65,
                    ),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final productData = snapshot.data![index];
                      final productImage = productData['images']
                          .replaceAll(RegExp(r'[\[\]"]'), '');
                      final imageUrl = baseUrl + productImage;
                      if (productData['highlight'] == 1) {
                        return InkWell(
                          onTap: (() => {
                                print(
                                    'produto Escolhido ${productData['name']}'),
                              }),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        print('Wish list Clicked');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Wish list clicked')));
                                      },
                                      child: Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 185,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Chip(
                                                      label: Text(
                                                        'R\$ ${productData['price']}',
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ]),
                                        ),
                                        ListTile(
                                          title: Text(productData['name']),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors
                                                    .yellow), // Ícone de estrela para representar avaliação
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star_half,
                                                color: Colors
                                                    .yellow), // Ícone de estrela pela metade
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child:
                                              Text(productData['description']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      } else {
                        return Container();
                      }

                      //Cards highlights
                    }),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'All Products',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.65,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Remova o scroll
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final productData = snapshot.data![index];
                      final productImage = productData['images']
                          .replaceAll(RegExp(r'[\[\]"]'), '');
                      final imageUrl = baseUrl + productImage;
                      if (productData.length >= 1) {
                        return InkWell(
                          onTap: (() => {
                                print(
                                    'produto Escolhido ${productData['name']}'),
                              }),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        print('Wish list Clicked');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Wish list clicked')));
                                      },
                                      child: Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 185,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Chip(
                                                      label: Text(
                                                        'R\$ ${productData['price']}',
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ]),
                                        ),
                                        ListTile(
                                          title: Text(productData['name']),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors
                                                    .yellow), // Ícone de estrela para representar avaliação
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star,
                                                color: Colors.yellow),
                                            Icon(Icons.star_half,
                                                color: Colors
                                                    .yellow), // Ícone de estrela pela metade
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child:
                                              Text(productData['description']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      } else {
                        return Container(
                          child: Text('Maconha'),
                        );
                      }
                    }),
              ],
            );
          } else {
            return Text('Nenhum produto encontrado');
          }
        });
  }
}
