import 'dart:convert';
import 'package:cartify/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCart(List<Product> cart) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = cart.map((e) => jsonEncode({
    "id": e.id,
    "title": e.title,
    "price": e.price,
    "image": e.image,
    "description": e.description,
  })).toList();

  prefs.setStringList('cart', jsonList);
}