import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';

List<TestListItem> sortTestList(List<TestListItem> items, {required String sortBy, required bool ascending}) {
  if (sortBy == 'all') {
    if (!ascending) return items.reversed.toList();
    return items;
  }
  final sorted = List<TestListItem>.of(items);
  switch (sortBy) {
    case 'time':
      sorted.sort((a, b) => a.estimatedTimeMinutes.compareTo(b.estimatedTimeMinutes));
      break;
    case 'severity':
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      sorted.sort((a, b) => (order[a.sensitivityLevel] ?? 3)
          .compareTo(order[b.sensitivityLevel] ?? 3));
      break;
    case 'items':
      sorted.sort((a, b) => a.questionCount.compareTo(b.questionCount));
      break;
    case 'name':
      sorted.sort((a, b) => a.name.compareTo(b.name));
      break;
  }
  if (!ascending) return sorted.reversed.toList();
  return sorted;
}
