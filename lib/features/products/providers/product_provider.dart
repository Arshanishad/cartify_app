import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/data/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = FutureProvider((ref) async {
  return ApiService().fetchProducts();
});

final quantityProvider = StateProvider<int>((ref) => 1);
final isLikedProvider = StateProvider<bool>((ref) => false);
final totalPriceProvider = Provider.family<double, Product>((ref, product) {
  final quantity = ref.watch(quantityProvider);
  return product.price * quantity;
});

final originalPriceProvider = Provider.family<double, Product>((ref, product) {
  final quantity = ref.watch(quantityProvider);
  return product.price * 1.3 * quantity;
});
