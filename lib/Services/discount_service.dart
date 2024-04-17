import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class DiscountService {
  Future<List<Map<String,dynamic>>> fetchDiscounts() async {
    final response = await http.get(Uri.parse('http://192.168.122.1:8000/api/'));

    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((discount) => discount as Map<String, dynamic>).toList();
    }
    else{
      throw Exception('Falha ao carregar discontos');
    }
  }

}


