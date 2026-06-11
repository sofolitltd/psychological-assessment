import 'package:psychological_assessment/features/upcoming/presentation/widgets/upcoming_test_model.dart';

List<UpcomingTestItem> sortUpcomingList(List<UpcomingTestItem> items, {required String sortBy, required bool ascending}) {
  if (sortBy == 'all') {
    if (!ascending) return items.reversed.toList();
    return items;
  }
  final sorted = List<UpcomingTestItem>.of(items);
  switch (sortBy) {
    case 'severity':
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      sorted.sort((a, b) => (order[a.test.sensitivityLevel] ?? 3)
          .compareTo(order[b.test.sensitivityLevel] ?? 3));
      break;
    case 'items':
      sorted.sort((a, b) => a.test.questionCount.compareTo(b.test.questionCount));
      break;
    case 'name':
      sorted.sort((a, b) => a.test.name.compareTo(b.test.name));
      break;
  }
  if (!ascending) return sorted.reversed.toList();
  return sorted;
}
