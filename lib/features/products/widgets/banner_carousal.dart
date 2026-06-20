// features/products/widgets/banner_carousel.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cartify/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cartify/core/constants/app_constants.dart';
import 'package:cartify/features/products/screens/product_list_screen.dart';

class BannerCarousel extends StatelessWidget {
  final List<BannerItem> banners;
  final bool isDark;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const BannerCarousel({
    super.key,
    required this.banners,
    required this.isDark,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDark ? Colors.grey[850] : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Column(
        children: [
          _buildCarousel(),
          const SizedBox(height: AppConstants.spacingSmall),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: 200,
        viewportFraction: 0.92,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        onPageChanged: (index, reason) => onPageChanged(index),
      ),
      items: banners.map((banner) => _buildBannerItem(banner)).toList(),
    );
  }

  Widget _buildBannerItem(BannerItem banner) {
    return GestureDetector(
      onTap: () => _onBannerTap(banner),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Stack(
            children: [
              _buildBannerImage(banner),
              _buildGradientOverlay(),
              _buildBannerTitle(banner),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerImage(BannerItem banner) {
    return CachedNetworkImage(
      imageUrl: banner.image,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: _buildPlaceholder,
      errorWidget: _buildErrorWidget,
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
        Icons.error_outline,
        color: isDark ? Colors.white70 : Colors.grey[600],
        size: 40,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildBannerTitle(BannerItem banner) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Text(
        banner.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: currentIndex,
      count: banners.length,
      effect: ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        spacing: 5,
        dotColor: isDark ? Colors.grey[600]! : Colors.grey[300]!,
        activeDotColor: isDark ? Colors.blue[300]! : AppColors.primaryBlue,
        paintStyle: PaintingStyle.fill,
      ),
    );
  }

  void _onBannerTap(BannerItem banner) {
    // Handle banner tap
    debugPrint('Banner tapped: ${banner.title}');
  }
}