// features/products/widgets/action_buttons.dart

import 'package:cartify/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cartify/core/constants/app_constants.dart';

class ActionButtons extends StatelessWidget {
  final int quantity;
  final Product product;
  final bool isDark;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ActionButtons({
    super.key,
    required this.quantity,
    required this.product,
    required this.isDark,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAddToCartButton(),
        const SizedBox(height: AppConstants.spacingSmall),
        _buildBuyNowButton(),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onAddToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            _buildQuantityBadge(Colors.white.withOpacity(0.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyNowButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onBuyNow,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Buy Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            _buildQuantityBadge(
              isDark ? Colors.grey[700]! : Colors.grey[200]!,
              textColor: isDark ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBadge(Color backgroundColor, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$quantity',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}