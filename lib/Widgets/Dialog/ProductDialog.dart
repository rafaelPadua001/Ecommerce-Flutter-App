import 'package:flutter/material.dart';
import '../../Services/product_dialog_service.dart';

class ProductDialog extends StatelessWidget {
  final ProductDialogService _productDialogService = ProductDialogService();
  final String productId;

  ProductDialog({Key? key, required String this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _productDialogService.fetchProductDialog(productId: productId),
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
            final productData = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Text(
                          '${productData}'),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container(
              child: Text('Merdaaaaaaa'),
            );
          }
        });
  }
}
