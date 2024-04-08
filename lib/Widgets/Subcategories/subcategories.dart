import 'package:flutter/material.dart';
import '../../Services/subcategory_service.dart';

class SubcategoryWidget extends StatelessWidget {
  final String categoryId;

  SubcategoryWidget({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final Subcategory subcategory = Subcategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategories'),
      ),
      body: FutureBuilder(
        future: Subcategory().fetchSubcategories(categoryId: categoryId),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (snapshot.data != null && index < snapshot.data!.length) {
                  final subcategoryData = snapshot.data![index];
                  return  ListTile(
                      title: Text(subcategoryData['name']),
                    );
                  
                } else {
                  // Se os dados forem nulos ou o índice estiver fora do intervalo, retorne um widget vazio
                  return SizedBox();
                }
              },
            );
          } else {
            return Text('Nenhum dado de categorias disponível.');
          }
        }),
    );
    
  }
}
