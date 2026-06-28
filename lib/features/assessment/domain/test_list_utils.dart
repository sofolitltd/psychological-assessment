import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';

bool isTestNew(TestListItem test) {
  if (test.createdAt.isEmpty) return false;
  final date = DateTime.tryParse(test.createdAt);
  if (date == null) return false;
  return DateTime.now().difference(date).inDays <= 30;
}

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
    case 'newest':
      sorted.sort((a, b) {
        final da = DateTime.tryParse(a.createdAt);
        final db = DateTime.tryParse(b.createdAt);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
      break;
  }
  if (!ascending) return sorted.reversed.toList();
  return sorted;
}
