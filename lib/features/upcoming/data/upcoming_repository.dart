import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/widgets/upcoming_test_model.dart';

final upcomingRepositoryProvider = Provider<UpcomingRepository>(
  (_) => UpcomingRepository(),
);

final upcomingTestListProvider = FutureProvider<List<UpcomingTestItem>>(
  (ref) => ref.read(upcomingRepositoryProvider).getUpcomingTests(),
);

class UpcomingRepository {
  Future<List<UpcomingTestItem>> getUpcomingTests() async {
    final raw = await rootBundle.loadString('assets/data/upcoming_manifest.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = data['upcoming_tests'] as List;
    return list
        .map((e) => UpcomingTestItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
