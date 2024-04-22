import 'package:flutter/material.dart';
import '../../Services/subcategory_product_service.dart';

class SubcategoryProductWidget extends StatelessWidget {
  final String subcategoryId;
  final imageUrl = 'http://192.168.122.1:8000/storage/products/';

  const SubcategoryProductWidget({Key? key, required this.subcategoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubcategoryProductService _subcategoruyProductService =
        SubcategoryProductService();
    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: FutureBuilder(
          future: _subcategoruyProductService.fetchSubcategoryProduct(
              subcategoryId: subcategoryId),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ao carregar ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.all(20),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    final productImages = product['images'];
                    final productImage = product['images']
                        .split(',')[0]
                        .trim()
                        .replaceAll(RegExp(r'[\[\]"]'), '');
                    final image = imageUrl + productImage;
                    return Container(
                      height: 175,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                        ),
                      ),
                      child: Card(
                        child: InkWell(
                          onTap: () => {
                            print('clicou no produto ${product['name']}'),
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Wrap(
                                    spacing: 8.0,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Chip(
                                          label: Text(product['price']),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                color: Colors.black.withOpacity(0.5),
                                child: Text(
                                  product['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          },
        ));
  }
}
