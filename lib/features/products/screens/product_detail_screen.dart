
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/features/cart/providers/cart_provider.dart';
import 'package:cartify/features/cart/screens/cart_page.dart';
import 'package:cartify/features/products/providers/product_provider.dart';
import 'package:cartify/features/products/widgets/product_detail_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartify/core/theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cartify/core/constants/app_constants.dart';
import 'package:cartify/features/products/widgets/product_image.dart';
import 'package:cartify/features/products/widgets/quantity_selector.dart';
import 'package:cartify/features/products/widgets/action_buttons.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {

  @override
  void dispose() {
    ref.read(quantityProvider.notifier).state = 1;
    ref.read(isLikedProvider.notifier).state = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final quantity = ref.watch(quantityProvider);
    final isLiked = ref.watch(isLikedProvider);
    final totalPrice = ref.watch(totalPriceProvider(widget.product));
    final originalPrice = ref.watch(originalPriceProvider(widget.product));

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(isDark, isLiked),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(product: widget.product, isDark: isDark),
            _buildProductDetails(isDark, quantity, totalPrice, originalPrice),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDark, bool isLiked) {
    return AppBar(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        _buildFavoriteButton(isDark, isLiked),
        _buildShareButton(isDark),
      ],
    );
  }

  IconButton _buildFavoriteButton(bool isDark, bool isLiked) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : (isDark ? Colors.white : Colors.black),
      ),
      onPressed: _toggleFavorite,
      splashRadius: 24,
    );
  }

  IconButton _buildShareButton(bool isDark) {
    return IconButton(
      icon: Icon(
        Icons.share_outlined,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: _shareProduct,
      splashRadius: 24,
    );
  }

 Widget _buildProductDetails(
    bool isDark,
    int quantity,
    double totalPrice,
    double originalPrice,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(isDark),
          const SizedBox(height: AppConstants.spacingSmall),
          _buildPriceAndQuantity(isDark, quantity, totalPrice, originalPrice),
          const SizedBox(height: AppConstants.spacingMedium),
          _buildDescription(isDark),
          const SizedBox(height: AppConstants.spacingMedium),
          ProductDetailsSection(isDark: isDark),
          const SizedBox(height: AppConstants.spacingMedium),
          ActionButtons(
            quantity: quantity,
            product: widget.product,
            isDark: isDark,
            onAddToCart: _addToCart,
            onBuyNow: _buyNow,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Text(
      widget.product.title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
        height: 1.3,
      ),
    );
  }

  Widget _buildPriceAndQuantity(
    bool isDark,
    int quantity,
    double totalPrice,
    double originalPrice,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceSection(isDark, totalPrice, originalPrice),
        QuantitySelector(
          quantity: quantity,
          isDark: isDark,
          onQuantityChanged: _updateQuantity,
        ),
      ],
    );
  }

  Widget _buildPriceSection(
    bool isDark,
    double totalPrice,
    double originalPrice,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Row(
          children: [
            Text(
              '₹${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Text(
              '₹${originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            _buildDiscountBadge(),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '30% OFF',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _buildDescription(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          widget.product.description,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    final currentState = ref.read(isLikedProvider);
    final newState = !currentState;
    ref.read(isLikedProvider.notifier).state = newState;

    _showSnackBar(
      message: newState ? 'Added to favorites ❤️' : 'Removed from favorites',
      color: newState ? Colors.green : Colors.grey,
    );
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity < 1) return; 
    ref.read(quantityProvider.notifier).state = newQuantity;
  }

  void _addToCart() {
    final quantity = ref.read(quantityProvider);
    for (int i = 0; i < quantity; i++) {
      ref.read(cartProvider.notifier).addToCart(widget.product);
    }

    _showSnackBar(
      message: '$quantity x ${widget.product.title} added to cart!',
      color: Colors.green,
      action: SnackBarAction(
        label: 'View Cart',
        textColor: Colors.white,
        onPressed: _navigateToCart,
      ),
    );
  }

  void _buyNow() {
    final quantity = ref.read(quantityProvider);
    for (int i = 0; i < quantity; i++) {
      ref.read(cartProvider.notifier).addToCart(widget.product);
    }
    _navigateToCart();
  }

  void _shareProduct() {
    final product = widget.product;
    final shareMessage =
        '''
🛍️ Check out this amazing product on Cartify!

📦 ${product.title}
💰 Price: ₹${product.price.toStringAsFixed(2)}
⭐ Rating: 4.5/5
🏷️ Category: ${product.category}

👇 Download Cartify now and get amazing deals! 🎉
    ''';

    // ignore: deprecated_member_use
    Share.share(shareMessage, subject: 'Check out ${product.title} on Cartify');
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _showSnackBar({
    required String message,
    required Color color,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: action,
      ),
    );
  }
}
