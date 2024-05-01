import 'dart:io' show Platform;
import 'package:ecommerce_clone_app/Services/auth_service.dart';

class ApiConfig {
 
 static String getApiBaseUrl(){
    if(Platform.isIOS){
      return 'http://host.docker.internal:8000/api';
    }
    else if(Platform.isAndroid){
      return 'http://192.168.122.1:8000/api';
    }
    else
    {
      return 'http://192.168.122.1:8000/api';
    }
  }
}