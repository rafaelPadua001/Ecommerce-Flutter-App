import 'package:flutter/material.dart';
import '../../Services/products_service.dart';
import '../../Services/wishlist_service.dart';
import '../../Services/discount_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import '../Dialog/ProductDialog.dart';

class Products extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Products> {
  final Product products = Product();
  final WishlistService wishlistService = WishlistService();
  final DiscountService discountService = DiscountService();
  List<Map<String, dynamic>> _discounts = [];
  final baseUrl = 'http://192.168.122.1:8000/storage/products/';
  final discountsUrl = 'http://192.168.122.1:8000/storage/Coupons/';
  @override
  void initState() {
    super.initState();
    _loadDiscounts();
  }

  @override
  void updateProductInWishlist() {
    setState(() {});
  }

  @override
  void _loadDiscounts() async {
    try {
      final discounts = await discountService.fetchDiscounts();
      setState(() {
        print(discounts);
        _discounts = discounts;
      });
    } catch (e) {
      throw Exception('Erro ao carregar descontos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: products.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                FutureBuilder(
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
                      final launcherProducts = snapshot.data!
                          .where((productData) => productData['launch'] == 1)
                          .toList();

                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                2, // Define o número de colunas na grade
                            crossAxisSpacing:
                                10, // Espaçamento entre as colunas
                            mainAxisSpacing: 8, // Espaçamento entre as linhas
                            childAspectRatio:
                                0.65, // Define a proporção entre a largura e a altura dos itens
                          ),
                          shrinkWrap: true,
                          itemCount: launcherProducts.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final productData = launcherProducts[index];

                            final productImage = productData['images']
                                .replaceAll(RegExp(r'[\[\]"]'), '');
                            final imageUrl = baseUrl + productImage;
                            if (productData['launch'] == 1) {
                              return InkWell(
                                onTap: (() => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDialog(
                                              productId:
                                                  productData['id'].toString()),
                                        ),
                                      )
                                    }),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: FutureBuilder<bool>(
                                            future: wishlistService
                                                .getProductWishlist(
                                                    productData['id']),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    try {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return;
                                                      }

                                                      if (snapshot.hasError) {
                                                        print(
                                                            'Error: ${snapshot.error}');
                                                        throw Exception(
                                                            'Error loading data ${snapshot.error}');
                                                      }

                                                      if (snapshot.data ==
                                                          true) {
                                                        await wishlistService
                                                            .destroy(productData[
                                                                    'id']
                                                                .toString());
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                '${productData['name']} removed from your wishlist'),
                                                          ),
                                                        );
                                                      } else {
                                                        await wishlistService
                                                            .store(productData);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Product added to your wishlist'),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        );
                                                      }

                                                      // Atualizar o estado do widget após adicionar/remover da lista de desejos
                                                      updateProductInWishlist();
                                                    } catch (e) {
                                                      // Lidar com erros
                                                      print('Error: $e');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content:
                                                              Text('Error: $e'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Icon(
                                                    snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Icons.favorite_outline
                                                        : snapshot.data == true
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_outline,
                                                    color: snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Colors.red
                                                        : snapshot.data == true
                                                            ? Colors.red
                                                            : Colors.grey,
                                                    size: 18,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Card(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                height: 185,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        NetworkImage(imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
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
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                              ListTile(
                                                title:
                                                    Text(productData['name']),
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
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                    productData['description']),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          });
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
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
                FutureBuilder(
                  future: products.fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          'Nenhum produto encontrado: ${snapshot.error}');
                    } else if (snapshot.data != null) {
                      final highlightProducts = snapshot.data!
                          .where((productData) => productData['highlight'] == 1)
                          .toList();
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.65,
                          ),
                          shrinkWrap: true,
                          itemCount: highlightProducts.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final productData = highlightProducts[index];
                            final productImages = productData['images'];

                            final productImage = productImages
                                .split(',')[0]
                                .trim()
                                .replaceAll(RegExp(r'[\[\]"]'), '');
                            final imageUrl = baseUrl + productImage;
                            if (productData['highlight'] == 1) {
                              return InkWell(
                                onTap: (() => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDialog(
                                              productId:
                                                  productData['id'].toString()),
                                        ),
                                      ),
                                    }),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: FutureBuilder<bool>(
                                            future: wishlistService
                                                .getProductWishlist(
                                                    productData['id']),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    try {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return;
                                                      }

                                                      if (snapshot.hasError) {
                                                        print(
                                                            'Error: ${snapshot.error}');
                                                        throw Exception(
                                                            'Error loading data ${snapshot.error}');
                                                      }

                                                      if (snapshot.data ==
                                                          true) {
                                                        await wishlistService
                                                            .destroy(productData[
                                                                    'id']
                                                                .toString());
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                '${productData['name']} removed from your wishlist'),
                                                          ),
                                                        );
                                                      } else {
                                                        await wishlistService
                                                            .store(productData);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Product added to your wishlist'),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        );
                                                      }

                                                      // Atualizar o estado do widget após adicionar/remover da lista de desejos
                                                      updateProductInWishlist();
                                                    } catch (e) {
                                                      // Lidar com erros
                                                      print('Error: $e');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content:
                                                              Text('Error: $e'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Icon(
                                                    snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Icons.favorite_outline
                                                        : snapshot.data == true
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_outline,
                                                    color: snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Colors.red
                                                        : snapshot.data == true
                                                            ? Colors.red
                                                            : Colors.grey,
                                                    size: 18,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Card(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                height: 185,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        NetworkImage(imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
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
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                              ListTile(
                                                title:
                                                    Text(productData['name']),
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
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                // child: Text(
                                                //     productData['description']),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text('Discounts'),
                _buildCarousel(),
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
                      final productImages = productData['images'];

                      final productImage = productImages
                          .split(',')[0]
                          .trim()
                          .replaceAll(RegExp(r'[\[\]"]'), '');
                      final imageUrl = baseUrl + productImage;
                      if (productData.length >= 1) {
                        return InkWell(
                          onTap: (() => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDialog(
                                        productId:
                                            productData['id'].toString()),
                                  ),
                                )
                              }),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: FutureBuilder<bool>(
                                      future:
                                          wishlistService.getProductWishlist(
                                              productData['id']),
                                      builder: (context, snapshot) {
                                        return Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () async {
                                              try {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return;
                                                }

                                                if (snapshot.hasError) {
                                                  print(
                                                      'Error: ${snapshot.error}');
                                                  throw Exception(
                                                      'Error loading data ${snapshot.error}');
                                                }

                                                if (snapshot.data == true) {
                                                  await wishlistService.destroy(
                                                      productData['id']
                                                          .toString());
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          '${productData['name']} removed from your wishlist'),
                                                    ),
                                                  );
                                                } else {
                                                  await wishlistService
                                                      .store(productData);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Product added to your wishlist'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                }

                                                // Atualizar o estado do widget após adicionar/remover da lista de desejos
                                                updateProductInWishlist();
                                              } catch (e) {
                                                // Lidar com erros
                                                print('Error: $e');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Icon(
                                              snapshot.connectionState ==
                                                      ConnectionState.waiting
                                                  ? Icons.favorite_outline
                                                  : snapshot.data == true
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                              color: snapshot.connectionState ==
                                                      ConnectionState.waiting
                                                  ? Colors.red
                                                  : snapshot.data == true
                                                      ? Colors.red
                                                      : Colors.grey,
                                              size: 18,
                                            ),
                                          ),
                                        );
                                      },
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
                                          // child:
                                          //     Text(productData['description']),
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

  Widget _buildCarousel() {
    if (_discounts.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        items: this._discounts.map((discount) {
          print(discount);
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 0.5),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    '${discountsUrl}${discount['images'].replaceAll('"', '')}',
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
                  ),
                  Text(
                      '${discount['code']} - ${discount['discount_percentage']}'),
                ],
              ),
            );
          });
        }).toList(),
      );
    } else {
      return SizedBox(
        height: 200, // Altura definida para corresponder à altura do carrossel
        child: Center(
          child: Text(
            'No discounts available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
