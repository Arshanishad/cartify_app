import 'dart:convert';
import 'package:cartify/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService{

  Future<List<Product>> fetchProducts() async{
    final response =await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return data.map<Product>((e)=>Product.fromJson(e)).toList();
    }else{
      throw Exception('Failed to load products');
    }
  }
}