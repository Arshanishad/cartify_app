// features/products/widgets/product_details_section.dart

import 'package:flutter/material.dart';
import 'package:cartify/core/constants/app_constants.dart';

class ProductDetailsSection extends StatelessWidget {
  final bool isDark;

  const ProductDetailsSection({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        _buildDetailRow('Category', 'Electronics'),
        _buildDetailRow('Brand', 'Samsung'),
        _buildDetailRow('Model', '2024'),
        _buildDetailRow('Warranty', '1 Year'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}