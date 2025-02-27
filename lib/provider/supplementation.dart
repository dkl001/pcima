import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/supplementation.dart';
import '../servises/db.dart';

final supplementationProvider =
    StateNotifierProvider<SupplementationNotifier, List<SupplementationPlan>>(
  (ref) => SupplementationNotifier(),
);

class SupplementationNotifier extends StateNotifier<List<SupplementationPlan>> {
  SupplementationNotifier() : super([]);

  final _dbHelper = DatabaseHelper();

  Future<void> loadPlans() async {
    final plansData = await _dbHelper.query('supplementation_plans');
    state = plansData.map((data) => SupplementationPlan.fromMap(data)).toList();
  }

  Future<void> addPlan(SupplementationPlan newPlan) async {
    await _dbHelper.insert('supplementation_plans', newPlan.toMap());
    state = [...state, newPlan];
  }
}
