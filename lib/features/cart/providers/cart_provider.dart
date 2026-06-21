import 'package:cartify/data/services/cart_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartify/data/models/product_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    state = [...state, product];
    saveCart(state);
  }

  void addMultiple(Product product, int quantity) {
    final newItems = List.generate(quantity, (_) => product);
    state = [...state, ...newItems];
    saveCart(state);
  }

  void removeFromCart(Product product) {
    state = state.where((p) => p.id != product.id).toList();
    saveCart(state);
  }

  void clearCart() {
    state = [];
    saveCart(state);
  }

  double get total => state.fold(0.0, (sum, item) => sum + item.price);
}
