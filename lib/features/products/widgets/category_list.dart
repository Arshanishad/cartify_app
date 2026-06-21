import 'package:flutter/material.dart';
import 'package:cartify/core/constants/app_constants.dart';
import 'package:cartify/features/products/screens/product_list_screen.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryItem> categories;
  final bool isDark;
  final Function(CategoryItem) onCategoryTap;

  const CategoryList({
    super.key,
    required this.categories,
    required this.isDark,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Colors.grey[850] : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppConstants.spacingMedium),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: Text(
        'Categories',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return SizedBox(
      height: 110, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingSmall,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryItem(category);
        },
      ),
    );
  }

  Widget _buildCategoryItem(CategoryItem category) {
    return InkWell(
      onTap: () => onCategoryTap(category),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            const SizedBox(height: 4),
            _buildCategoryIcon(category),
            const SizedBox(height: 6),
            Expanded(
              child: Center(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(CategoryItem category) {
    return CircleAvatar(
      radius: 24, 
      backgroundColor: isDark ? Colors.grey[700] : Colors.blue.shade50,
      child: Icon(
        category.icon,
        size: 24,
        color: isDark ? Colors.white : Colors.blue.shade700,
      ),
    );
  }
}
