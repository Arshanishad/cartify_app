// features/products/widgets/product_image.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cartify/core/constants/app_constants.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final bool isDark;

  const ProductImage({
    super.key,
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Hero(
      tag: product.id,
      child: Container(
        width: double.infinity,
        height: size.height * 0.45,
        color: isDark ? Colors.grey[800] : Colors.white,
        child: CachedNetworkImage(
          imageUrl: product.image,
          fit: BoxFit.contain,
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
        size: 80,
        color: isDark ? Colors.white70 : Colors.grey[600],
      ),
    );
  }
}