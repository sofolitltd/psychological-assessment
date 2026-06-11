import 'package:flutter/material.dart';

import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';
import 'package:psychological_assessment/core/widgets/test_filter_chip.dart';

class TestCategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final List<TestListItem> tests;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const TestCategoryFilterBar({
    super.key,
    required this.categories,
    required this.tests,
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
            count: tests.length,
            onTap: () => onCategoryChanged(null),
          ),
          const SizedBox(width: 8),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TestFilterChip(
                label: category,
                selected: selectedCategory == category,
                count: tests.where((t) => t.category == category).length,
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
