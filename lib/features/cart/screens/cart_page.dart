import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/features/cart/providers/cart_provider.dart';
import 'package:cartify/core/theme.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final isDarkMode = ref.watch(themeProvider);
    final totalPrice = ref.watch(cartProvider.notifier).total;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(cartItems.length, isDarkMode, ref, context),
      body: cartItems.isEmpty
          ? _buildEmptyState(isDarkMode, context)
          : _buildCartContent(cartItems, totalPrice, isDarkMode, ref, context),
    );
  }

  //AppBar
  PreferredSizeWidget _buildAppBar(
    int itemCount,
    bool isDarkMode,
    WidgetRef ref,
    BuildContext context,
  ) {
    return AppBar(
      title: Text(
        'My Cart ($itemCount)',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (itemCount > 0) _buildClearCartButton(isDarkMode, ref,context),
      ],
    );
  }

  Widget _buildClearCartButton(bool isDarkMode, WidgetRef ref,BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: isDarkMode ? Colors.white : Colors.red,
      ),
      onPressed: () => _showClearCartDialog(context, ref),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Clear Cart',
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Looks like you haven\'t added anything to your cart yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    List<Product> cartItems,
    double totalPrice,
    bool isDarkMode,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cartItems.length,
            itemBuilder: (_, index) {
              final product = cartItems[index];
              return _buildCartItem(product, isDarkMode, ref,context);
            },
          ),
        ),
        _buildCartSummary(cartItems, totalPrice, isDarkMode, ref, context),
      ],
    );
  }

  Widget _buildCartItem(
    Product product,
    bool isDarkMode,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildProductImage(product, isDarkMode),
            const SizedBox(width: 12),
            _buildProductDetails(product, isDarkMode),
            _buildRemoveButton(product, isDarkMode, ref,context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product, bool isDarkMode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: product.image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: 80,
          height: 80,
          color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) => Container(
          width: 80,
          height: 80,
          color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
          child: Icon(
            Icons.image_not_supported,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(Product product, bool isDarkMode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          _buildProductTags(),
        ],
      ),
    );
  }

  Widget _buildProductTags() {
    return Row(
      children: [
        _buildTag('In Stock', Colors.green),
        const SizedBox(width: 8),
        _buildTag('Free Delivery', Colors.orange),
      ],
    );
  }

  Widget _buildTag(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRemoveButton(
    Product product,
    bool isDarkMode,
    WidgetRef ref,
    BuildContext context
  ) {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: isDarkMode ? Colors.white70 : Colors.grey[600],
      ),
      onPressed: () => _showRemoveConfirmationDialog(context, product, ref),
    );
  }

  void _showRemoveConfirmationDialog(
    BuildContext context,
    Product product,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Remove Item',
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: Text(
          'Remove "${product.title}" from your cart?',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).removeFromCart(product);
              Navigator.pop(context);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(
    List<Product> cartItems,
    double totalPrice,
    bool isDarkMode,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal (${cartItems.length} items)',
            '₹${totalPrice.toStringAsFixed(2)}',
            isDarkMode,
            isBold: false,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Delivery Charges',
            '₹0.00',
            isDarkMode,
            valueColor: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Total Savings',
            '₹${(totalPrice * 0.3).toStringAsFixed(2)}',
            isDarkMode,
            valueColor: Colors.green,
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total Amount',
            '₹${totalPrice.toStringAsFixed(2)}',
            isDarkMode,
            isTotal: true,
          ),
          const SizedBox(height: 16),
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDarkMode, {
    Color? valueColor,
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDarkMode
                ? (isTotal ? Colors.white : Colors.grey[400])
                : (isTotal ? Colors.black : Colors.grey[600]),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 24 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proceeding to checkout...'),
              backgroundColor: Colors.green,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Proceed to Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}