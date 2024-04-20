import 'package:ecommerce_clone_app/Widgets/SubcategoryProducts/SubcategoryProduct.dart';
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
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                 crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                padding: const EdgeInsets.all(20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data != null && index < snapshot.data!.length) {
                    final subcategoryData = snapshot.data![index];
                    return Card(
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubcategoryProductWidget(subcategoryId: subcategoryData['id'].toString())),
                          ),
                         
                        },
                        child: Column(children: [
                          ListTile(
                            title: Text(subcategoryData['name']),
                            subtitle: Text(subcategoryData['name']),
                          ),
                        ]),
                      ),
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
