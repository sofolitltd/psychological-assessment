import 'package:flutter/material.dart';

import 'package:psychological_assessment/core/widgets/test_filter_chip.dart';
import 'package:psychological_assessment/features/upcoming/presentation/widgets/upcoming_test_model.dart';

class UpcomingCategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final List<UpcomingTestItem> items;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const UpcomingCategoryFilterBar({
    super.key,
    required this.categories,
    required this.items,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          TestFilterChip(
            label: 'All',
            selected: selectedCategory == null,
            count: items.length,
            onTap: () => onCategoryChanged(null),
          ),
          const SizedBox(width: 8),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TestFilterChip(
                label: category,
                selected: selectedCategory == category,
                count: items.where((t) => t.test.category == category).length,
                onTap: () => onCategoryChanged(
                  selectedCategory == category ? null : category,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
