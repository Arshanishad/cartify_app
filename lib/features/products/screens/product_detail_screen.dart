// features/products/screens/product_detail_screen.dart

import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/features/cart/providers/cart_provider.dart';
import 'package:cartify/features/cart/screens/cart_page.dart';
import 'package:cartify/features/products/widgets/product_detail_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartify/core/theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cartify/core/constants/app_constants.dart';
import 'package:cartify/features/products/widgets/product_image.dart';
import 'package:cartify/features/products/widgets/quantity_selector.dart';
import 'package:cartify/features/products/widgets/action_buttons.dart';
import 'package:cartify/features/products/widgets/rating_widget.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  bool _isLiked = false;

  // ==================== GETTERS ====================

  double get _totalPrice => widget.product.price * _quantity;
  double get _originalPrice => widget.product.price * 1.3 * _quantity;
  bool get _isDark => ref.watch(themeProvider);

  // ==================== LIFECYCLE ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(product: widget.product, isDark: _isDark),
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }

  // ==================== APP BAR ====================

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _isDark ? Colors.grey[900] : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: _isDark ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [_buildFavoriteButton(), _buildShareButton()],
    );
  }

  IconButton _buildFavoriteButton() {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : (_isDark ? Colors.white : Colors.black),
      ),
      onPressed: _toggleFavorite,
    );
  }

  IconButton _buildShareButton() {
    return IconButton(
      icon: Icon(
        Icons.share_outlined,
        color: _isDark ? Colors.white : Colors.black,
      ),
      onPressed: _shareProduct,
    );
  }

  // ==================== PRODUCT DETAILS ====================

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: _isDark ? Colors.grey[850] : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: AppConstants.spacingSmall),
          const RatingWidget(
            rating: 4.5,
            totalRatings: 2345,
            totalReviews: 256,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          _buildPriceAndQuantity(),
          const SizedBox(height: AppConstants.spacingMedium),
          _buildDescription(),
          const SizedBox(height: AppConstants.spacingMedium),
          ProductDetailsSection(isDark: _isDark),
          const SizedBox(height: AppConstants.spacingMedium),
          ActionButtons(
            quantity: _quantity,
            product: widget.product,
            isDark: _isDark,
            onAddToCart: _addToCart,
            onBuyNow: _buyNow,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
        ],
      ),
    );
  }

  // ==================== UI COMPONENTS ====================

  Widget _buildTitle() {
    return Text(
      widget.product.title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _isDark ? Colors.white : Colors.black,
        height: 1.3,
      ),
    );
  }

  Widget _buildPriceAndQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceSection(),
        QuantitySelector(
          quantity: _quantity,
          isDark: _isDark,
          onQuantityChanged: _updateQuantity,
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TextStyle(
            fontSize: 14,
            color: _isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Row(
          children: [
            Text(
              '₹${_totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Text(
              '₹${_originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: _isDark ? Colors.grey[500] : Colors.grey[400],
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

  Widget _buildDescription() {
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
            color: _isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          widget.product.description,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: _isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // ==================== ACTIONS ====================

  void _toggleFavorite() {
    setState(() => _isLiked = !_isLiked);
    _showSnackBar(
      _isLiked ? 'Added to favorites ❤️' : 'Removed from favorites',
      _isLiked ? Colors.green : Colors.grey,
    );
  }

  void _updateQuantity(int newQuantity) {
    setState(() => _quantity = newQuantity);
  }

  void _addToCart() {
    for (int i = 0; i < _quantity; i++) {
      ref.read(cartProvider.notifier).addToCart(widget.product);
    }
    _showSnackBar(
      '$_quantity x ${widget.product.title} added to cart!',
      Colors.green,
      action: SnackBarAction(
        label: 'View Cart',
        textColor: Colors.white,
        onPressed: () => _navigateToCart(),
      ),
    );
  }

  void _buyNow() {
    for (int i = 0; i < _quantity; i++) {
      ref.read(cartProvider.notifier).addToCart(widget.product);
    }
    _navigateToCart();
  }

  void _shareProduct() {
    Share.share('''
🛍️ Check out this product on Cartify!

📦 Product: ${widget.product.title}
💰 Price: ₹${widget.product.price.toStringAsFixed(2)}
⭐ Rating: 4.5/5

Shop now and get amazing deals! 🎉
      ''', subject: 'Check out ${widget.product.title}');
  }

  // ==================== NAVIGATION ====================

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  // ==================== HELPERS ====================

  void _showSnackBar(String message, Color color, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
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
