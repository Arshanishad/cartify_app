import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cartify/core/constants/app_constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isDark;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: isDark ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Expanded(
      flex: 6,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusMedium),
        ),
        child: CachedNetworkImage(
          imageUrl: product.image,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: _buildPlaceholder,
          errorWidget: _buildErrorWidget,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String url) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        color: isDark ? Colors.grey[700] : Colors.grey[300],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    return Container(
      color: isDark ? Colors.grey[700] : Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: isDark ? Colors.white70 : Colors.grey[600],
        size: 40,
      ),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
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
              '₹${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}