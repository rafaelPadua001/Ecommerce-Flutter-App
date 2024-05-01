import 'dart:io' show Platform;
import 'package:ecommerce_clone_app/Services/auth_service.dart';

class ApiConfig {
 
 static String getApiBaseUrl(){
    if(Platform.isIOS){
      return 'http://host.docker.internal:8000/api';
    }
    else if(Platform.isAndroid){
      return 'http://10.0.2.2:8000/api';
    }
    else
    {
      return 'http://localhost:8000/api';
    }
  }
}