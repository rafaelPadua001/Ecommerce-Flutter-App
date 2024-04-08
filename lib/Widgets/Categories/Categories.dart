import 'package:flutter/material.dart';
import '../../Services/category_service.dart';

class CategoriesWidget extends StatelessWidget {
  final Category category = Category();

  @override
  Widget build(BuildContext context){
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: category.fetchCategories(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );

        }
        else if (snapshot.hasError){
          return Center(
              child: Text('Error: ${snapshot.error}'),
          );
        
        }
        else if(snapshot.data != null){
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final categoryData = snapshot.data![index];
              return ListTile(
                title: Text(categoryData['name']),
              );
            },
          );
        }
        else{
          return Text('Nenhum dado de categorias disponível.');
        }
      });
  }
}