import 'package:cartify/core/constants/image_constants.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/features/cart/screens/cart_page.dart';
import 'package:cartify/features/products/screens/category_screen.dart';
import 'package:cartify/features/products/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartify/core/theme.dart';
import 'package:cartify/features/products/providers/product_provider.dart';
import 'package:cartify/features/products/screens/product_detail_screen.dart';
import 'package:cartify/features/products/widgets/category_list.dart';
import 'package:cartify/features/products/widgets/product_card.dart';
import 'package:cartify/features/products/widgets/loading_skeleton.dart';
import 'package:cartify/core/constants/app_constants.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {

  final List<CategoryItem> _categories = const [
    CategoryItem(
      icon: Icons.electrical_services,
      name: 'Electronics',
      filter: 'electronics',
    ),
    CategoryItem(
      icon: Icons.checkroom,
      name: 'Men\'s Clothing',
      filter: 'men\'s clothing',
    ),
    CategoryItem(
      icon: Icons.female,
      name: 'Women\'s Clothing',
      filter: 'women\'s clothing',
    ),
    CategoryItem(icon: Icons.diamond, name: 'Jewelery', filter: 'jewelery'),
  ];

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(isDark),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildHeaderSliver(isDark),
        ],
        body: _buildProductBody(products, isDark),
      ),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      surfaceTintColor: isDark ? Colors.grey[900] : Colors.white,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      elevation: 0,
      title: Text(
        'Cartify',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _buildSearchButton(isDark),
        _buildCartButton(isDark),
        _buildThemeToggleButton(isDark),
      ],
    );
  }

  IconButton _buildSearchButton(bool isDark) {
    return IconButton(
      icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
      onPressed: () => _navigateToSearch(context),
    );
  }

  IconButton _buildCartButton(bool isDark) {
    return IconButton(
      icon: Icon(
        Icons.shopping_cart_outlined,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: () => _navigateToCart(context),
    );
  }

  IconButton _buildThemeToggleButton(bool isDark) {
    return IconButton(
      icon: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: () => _toggleTheme(),
    );
  }

  SliverList _buildHeaderSliver(bool isDark) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Column(
          children: [
            CategoryList(
              categories: _categories,
              isDark: isDark,
              onCategoryTap: (category) =>
                  _navigateToCategory(context, category),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            _buildSectionHeader(isDark),
          ],
        ),
        childCount: 1,
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See All',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductBody(AsyncValue<List<Product>> products, bool isDark) {
    return products.when(
      data: (data) => _buildProductGrid(data, isDark),
      loading: () => const LoadingSkeleton(),
      error: (error, _) => _buildErrorWidget(error, isDark),
    );
  }

  Widget _buildProductGrid(List<Product> products, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingSmall),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppConstants.gridCrossAxisCount,
        childAspectRatio: AppConstants.gridChildAspectRatio,
        crossAxisSpacing: AppConstants.gridSpacing,
        mainAxisSpacing: AppConstants.gridSpacing,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
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

  void _navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _navigateToCategory(BuildContext context, CategoryItem category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoryName: category.name,
          categoryFilter: category.filter,
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product)),
    );
  }

  void _toggleTheme() {
    ref.read(themeProvider.notifier).state = !ref.read(themeProvider);
  }
}

class BannerItem {
  final String image;
  final String title;

  const BannerItem({required this.image, required this.title});
}

class CategoryItem {
  final IconData icon;
  final String name;
  final String filter;

  const CategoryItem({
    required this.icon,
    required this.name,
    required this.filter,
  });
}
