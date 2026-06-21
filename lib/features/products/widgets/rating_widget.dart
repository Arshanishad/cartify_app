import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int totalRatings;
  final int totalReviews;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.totalRatings,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _buildRatingBadge(),
        const SizedBox(width: 8),
        Text(
          '$totalRatings Ratings',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$totalReviews Reviews',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}