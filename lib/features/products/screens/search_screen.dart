import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cartify/core/theme.dart';
import 'package:cartify/features/products/providers/product_provider.dart';
import 'package:cartify/features/products/screens/product_detail_screen.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return products.when(
    data: (data) {
      if (searchQuery.isEmpty) return data;
      final query = searchQuery.toLowerCase().trim();
      return data.where((product) {
        return product.title.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }).toList();
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final productsState = ref.watch(productProvider.select((value) => value));
    final filteredProducts = ref.watch(filteredProductsProvider);
    final searchQuery = ref.watch(searchQueryProvider.select((value) => value));
    final isSearching = searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: productsState.when(
        data: (data) {
          if (filteredProducts.isEmpty && isSearching) {
            return _buildEmptyState(
              icon: Icons.search_off,
              message: 'No results found for "$searchQuery"',
              isDark: isDark,
              showButton: true,
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            );
          }
          if (filteredProducts.isEmpty) {
            return _buildEmptyState(
              icon: Icons.shopping_bag_outlined,
              message: 'Start searching for products',
              isDark: isDark,
              showButton: false,
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (_, i) {
              final product = filteredProducts[i];
              return _buildProductCard(product, isDark, context);
            },
          );
        },
        loading: () => _buildLoadingSkeleton(isDark),
        error: (e, _) => Center(
          child: Text(
            "Error loading products: ${e.toString()}",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required bool isDark,
    required bool showButton,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (showButton) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onPressed, child: const Text('Clear Search')),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, bool isDark, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product)),
        );
      },
      child: Card(
        elevation: 2,
        color: isDark ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    highlightColor: isDark
                        ? Colors.grey[600]!
                        : Colors.grey[100]!,
                    child: Container(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? Colors.grey[700] : Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            // Product Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      "₹${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
          child: Card(
            color: isDark ? Colors.grey[700] : Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
