// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../provider/supplementation.dart';

// class SupplementationScreen extends ConsumerWidget {
//   final String targetGroup;

//   const SupplementationScreen({super.key, required this.targetGroup});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final plans = ref.watch(supplementationProvider);

//     final filteredPlans =
//         plans.where((plan) => plan.targetGroup == targetGroup).toList();

//     return Scaffold(
//       appBar: AppBar(title: Text('Supplémentation pour $targetGroup')),
//       body: filteredPlans.isEmpty
//           ? const Center(child: Text('Aucun plan trouvé.'))
//           : ListView.builder(
//               itemCount: filteredPlans.length,
//               itemBuilder: (context, index) {
//                 final plan = filteredPlans[index];
//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           plan.productName,
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text("Ration Journalière : ${plan.dailyRation} g"),
//                         Text("Énergie : ${plan.energy} Kcal"),
//                         Text("Protéines : ${plan.protein} g"),
//                         Text("Lipides : ${plan.fat} g"),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SupplementationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> supplementationData = [
    {
      "product": "Plumpy Sup",
      "targetGroup": "Enfants 6-59 mois",
      "dailyRation": "100 g",
      "energy": "500 Kcal",
      "protein": "12.5 g",
      "fat": "32.9 g",
    },
    {
      "product": "Super Cereal",
      "targetGroup": "Femmes enceintes",
      "dailyRation": "250 g + 25 g huile",
      "energy": "1171 Kcal",
      "protein": "45 g",
      "fat": "39 g",
    },
  ];

  SupplementationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Supplémentation Nutritionnelle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isTablet
            ? _buildTable(supplementationData)
            : _buildList(supplementationData),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(item['product']),
            subtitle: Text(item['targetGroup']),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Ration : ${item['dailyRation']}"),
                Text("Énergie : ${item['energy']}"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Produit')),
          DataColumn(label: Text('Groupe cible')),
          DataColumn(label: Text('Ration')),
          DataColumn(label: Text('Énergie')),
          DataColumn(label: Text('Protéines')),
          DataColumn(label: Text('Lipides')),
        ],
        rows: data.map((item) {
          return DataRow(cells: [
            DataCell(Text(item['product'])),
            DataCell(Text(item['targetGroup'])),
            DataCell(Text(item['dailyRation'])),
            DataCell(Text(item['energy'])),
            DataCell(Text(item['protein'])),
            DataCell(Text(item['fat'])),
          ]);
        }).toList(),
      ),
    );
  }
}
