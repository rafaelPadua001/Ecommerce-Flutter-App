import 'package:flutter/material.dart';
import '../../Services/subcategory_product_service.dart';

class SubcategoryProductWidget extends StatelessWidget {
  final String subcategoryId;

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
                    return Card(
                      child: InkWell(
                        onTap: () => {
                          print('clicou no produto ${product['name']}'),
                        },
                        child: ListTile(
                          title: Text(product['name']),
                          subtitle: Text(product['price']),
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
