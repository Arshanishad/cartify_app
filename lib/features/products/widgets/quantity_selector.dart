// features/products/widgets/quantity_selector.dart

import 'package:flutter/material.dart';
import 'package:cartify/core/constants/app_constants.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final bool isDark;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.isDark,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: Row(
        children: [
          _buildDecrementButton(),
          _buildQuantityText(),
          _buildIncrementButton(),
        ],
      ),
    );
  }

  Widget _buildDecrementButton() {
    return IconButton(
      icon: Icon(
        Icons.remove,
        size: 18,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        if (quantity > 1) {
          onQuantityChanged(quantity - 1);
        }
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildQuantityText() {
    return Text(
      '$quantity',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildIncrementButton() {
    return IconButton(
      icon: Icon(
        Icons.add,
        size: 18,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: () => onQuantityChanged(quantity + 1),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}