import 'package:flutter/material.dart';
import '../../Services/banner_service.dart';

class BannerWidget extends StatelessWidget{
  final BannerService bannerService = BannerService();
  final bannerUrl = 'http://192.168.122.1:8000/storage/Banners/';
  late Future<List<Map<String, dynamic>>> bannerFuture; 

  @override 
  Widget build(BuildContext context){
    return FutureBuilder<List<Map<String,dynamic>>> (
      future: bannerService.fetchBanners(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(snapshot.hasError){
       
          return Center(
            
            child: Text('Error: ${snapshot.error}'),
          );
        }
        else if(snapshot.hasData){
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final banner = snapshot.data![index];
              final bannerData = banner[index];
              final imageName = banner['image'].replaceAll('"', '');
              final imageUrl = bannerUrl + imageName;
              return ListTile(
                 title: Image.network(imageUrl),
              );
            });
        }
        else
        {
          return Container();
        }
      });
  }
}