import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/features/products/screens/product_detail_screen.dart' show ProductDetailScreen;
import 'package:cartify/features/products/widgets/product_card.dart';
import 'package:cartify/features/products/widgets/loading_skeleton.dart';
import 'package:cartify/features/products/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartify/core/theme.dart';
import 'package:cartify/features/products/providers/product_provider.dart';

class CategoryProductsScreen extends ConsumerWidget {
  final String categoryName;
  final String categoryFilter;
  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.categoryFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    final isDark = ref.watch(themeProvider);
    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: productsAsync.when(
        data: (products) => _buildProductGrid(products, isDark, context),
        loading: () => const LoadingSkeleton(),
        error: (error, _) => _buildErrorWidget(error, isDark),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        categoryName,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products, bool isDark, BuildContext context) {
    final filteredProducts = products
        .where((product) => product.category == categoryFilter)
        .toList();
    if (filteredProducts.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.category_outlined,
        title: 'No Products Found',
        message: 'No products found in $categoryName',
        buttonText: 'Go Back',
        onPressed: () => Navigator.pop(context),
        isDark: isDark,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(
          product: product,
          isDark: isDark,
          onTap: () => _navigateToProductDetail(context, product),
        );
      },
    );
  }
  Widget _buildErrorWidget(Object error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product),
      ),
    );
  }
}