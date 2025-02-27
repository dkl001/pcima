
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/nutrition.dart';
// import '../servises/db.dart';

// final nutritionCasesProvider =
//     StateNotifierProvider<NutritionCasesNotifier, List<NutritionCase>>(
//   (ref) => NutritionCasesNotifier(),
// );

// class NutritionCasesNotifier extends StateNotifier<List<NutritionCase>> {
//   NutritionCasesNotifier() : super([]);

//   final _dbHelper = DatabaseHelper();

//   Future<void> loadCases() async {
//     final casesData = await _dbHelper.query('nutrition_cases');
//     state = casesData.map((data) => NutritionCase.fromMap(data)).toList();
//   }

//   Future<void> addCase(NutritionCase newCase) async {
//     await _dbHelper.insert('nutrition_cases', newCase.toMap());
//     state = [...state, newCase];
//   }
// }
