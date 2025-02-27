// // // import 'package:flutter/material.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';

// // // class SuiviEtatNutritionnelPage extends StatefulWidget {
// // //   final String enfantId; // Identifiant unique de l'enfant

// // //   const SuiviEtatNutritionnelPage({Key? key, required this.enfantId})
// // //       : super(key: key);

// // //   @override
// // //   _SuiviEtatNutritionnelPageState createState() =>
// // //       _SuiviEtatNutritionnelPageState();
// // // }

// // // class _SuiviEtatNutritionnelPageState extends State<SuiviEtatNutritionnelPage> {
// // //   final supabase = Supabase.instance.client;

// // //   List<Map<String, dynamic>> visites = [];
// // //   bool isLoading = true;

// // //   final TextEditingController poidsController = TextEditingController();
// // //   final TextEditingController tailleController = TextEditingController();
// // //   final TextEditingController pbController = TextEditingController();

// // //   /// Récupération des données de suivi de l'enfant
// // //   Future<void> fetchSuiviData() async {
// // //     try {
// // //       final response = await supabase
// // //           .from('suivi') // Nom de votre table pour le suivi
// // //           .select()
// // //           .eq('enfant_id', widget.enfantId);

// // //       if (response.error != null) {
// // //         throw response.error!;
// // //       }

// // //       setState(() {
// // //         visites = List<Map<String, dynamic>>.from(response.data);
// // //         isLoading = false;
// // //       });
// // //     } catch (e) {
// // //       setState(() {
// // //         isLoading = false;
// // //       });
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Erreur lors du chargement des données.")),
// // //       );
// // //     }
// // //   }

// // //   /// Ajout des données de visite
// // //   Future<void> ajouterVisite() async {
// // //     try {
// // //       double poids = double.parse(poidsController.text);
// // //       double taille = double.tryParse(tailleController.text) ?? 0.0;
// // //       double pb = double.parse(pbController.text);

// // //       final response = await supabase.from('suivi').insert({
// // //         'enfant_id': widget.enfantId,
// // //         'date': DateTime.now().toIso8601String(),
// // //         'poids': poids,
// // //         'taille': taille > 0 ? taille : null,
// // //         'pb': pb,
// // //       });

// // //       if (response.error != null) {
// // //         throw response.error!;
// // //       }

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Visite ajoutée avec succès.")),
// // //       );

// // //       poidsController.clear();
// // //       tailleController.clear();
// // //       pbController.clear();

// // //       // Recharge les données
// // //       fetchSuiviData();
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Erreur lors de l'ajout des données.")),
// // //       );
// // //     }
// // //   }

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchSuiviData();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Suivi de l'État Nutritionnel"),
// // //       ),
// // //       body: isLoading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : Padding(
// // //               padding: const EdgeInsets.all(16.0),
// // //               child: SingleChildScrollView(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     const Text(
// // //                       "Ajouter une visite",
// // //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 10),

// // //                     // Champ pour le poids
// // //                     TextField(
// // //                       controller: poidsController,
// // //                       keyboardType: TextInputType.number,
// // //                       decoration: const InputDecoration(
// // //                         labelText: "Poids (kg)",
// // //                         border: OutlineInputBorder(),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),

// // //                     // Champ pour la taille
// // //                     TextField(
// // //                       controller: tailleController,
// // //                       keyboardType: TextInputType.number,
// // //                       decoration: const InputDecoration(
// // //                         labelText: "Taille (cm) - Optionnel",
// // //                         border: OutlineInputBorder(),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),

// // //                     // Champ pour le PB
// // //                     TextField(
// // //                       controller: pbController,
// // //                       keyboardType: TextInputType.number,
// // //                       decoration: const InputDecoration(
// // //                         labelText: "PB (mm)",
// // //                         border: OutlineInputBorder(),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 20),

// // //                     // Bouton d'ajout de visite
// // //                     ElevatedButton(
// // //                       onPressed: ajouterVisite,
// // //                       child: const Text("Ajouter la Visite"),
// // //                       style: ElevatedButton.styleFrom(
// // //                         minimumSize: const Size(double.infinity, 50),
// // //                         textStyle: const TextStyle(fontSize: 18),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 20),

// // //                     // Liste des visites
// // //                     const Text(
// // //                       "Historique des Visites",
// // //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     ...visites.map((visite) {
// // //                       String ptIndice = visite['taille'] != null
// // //                           ? (visite['poids'] / (visite['taille'] / 100).toDouble())
// // //                               .toStringAsFixed(2)
// // //                           : "N/A";

// // //                       return Card(
// // //                         child: ListTile(
// // //                           title: Text(
// // //                               "Date : ${DateTime.parse(visite['date']).toLocal()}"),
// // //                           subtitle: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               Text("Poids : ${visite['poids']} kg"),
// // //                               Text("Taille : ${visite['taille'] ?? 'N/A'} cm"),
// // //                               Text("PB : ${visite['pb']} mm"),
// // //                               if (visite['taille'] != null)
// // //                                 Text("Indice P/T : $ptIndice"),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:table_calendar/table_calendar.dart';

// // class SuiviEtatNutritionnelPage extends StatefulWidget {
// //   final String enfantId; // Identifiant unique de l'enfant

// //   const SuiviEtatNutritionnelPage({super.key, required this.enfantId});

// //   @override
// //   _SuiviEtatNutritionnelPageState createState() =>
// //       _SuiviEtatNutritionnelPageState();
// // }

// // class _SuiviEtatNutritionnelPageState extends State<SuiviEtatNutritionnelPage> {
// //   final supabase = Supabase.instance.client;

// //   DateTime selectedDate = DateTime.now();
// //   DateTime firstVisitDate = DateTime.now();
// //   List<Map<String, dynamic>> visites = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchSuiviData();
// //     _setFirstVisitDate();
// //   }

// //   /// Récupération des données de suivi de l'enfant
// //   Future<void> fetchSuiviData() async {
// //     try {
// //       final response = await supabase
// //           .from('suivi') // Nom de votre table pour le suivi
// //           .select()
// //           .eq('enfant_id', widget.enfantId)
// //           .order('date', ascending: true);

// //       if (response.error != null) {
// //         throw response.error!;
// //       }

// //       setState(() {
// //         visites = List<Map<String, dynamic>>.from(response.data);
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Erreur lors du chargement des données.")),
// //       );
// //     }
// //   }

// //   /// Fonction pour définir la première visite
// //   void _setFirstVisitDate() {
// //     final now = DateTime.now();
// //     final firstVisit = DateTime(now.year, now.month, now.day);
// //     setState(() {
// //       firstVisitDate = firstVisit;
// //     });
// //   }

// //   /// Fonction pour ajouter une nouvelle visite
// //   Future<void> ajouterVisite() async {
// //     try {
// //       final DateTime nextVisit = firstVisitDate.add(const Duration(days: 14));

// //       final response = await supabase.from('suivi').insert({
// //         'enfant_id': widget.enfantId,
// //         'date': nextVisit.toIso8601String(),
// //       });

// //       if (response.error != null) {
// //         throw response.error!;
// //       }

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Visite ajoutée pour : $nextVisit")),
// //       );

// //       // Recharge les données
// //       fetchSuiviData();
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Erreur lors de l'ajout de la visite.")),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Suivi de l'État Nutritionnel"),
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       "Suivi des Visites",
// //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     Text(
// //                         "Première visite programmée : ${firstVisitDate.toLocal()}"),
// //                     const SizedBox(height: 20),

// //                     // Table Calendar pour visualiser les dates de visites
// //                     TableCalendar(
// //                       focusedDay: selectedDate,
// //                       firstDay: DateTime.utc(2020, 1, 1),
// //                       lastDay: DateTime.utc(2025, 12, 31),
// //                       selectedDayPredicate: (day) {
// //                         return isSameDay(day, selectedDate);
// //                       },
// //                       onDaySelected: (selectedDay, focusedDay) {
// //                         setState(() {
// //                           selectedDate = selectedDay;
// //                         });
// //                       },
// //                     ),
// //                     const SizedBox(height: 20),

// //                     // Bouton pour ajouter la visite
// //                     ElevatedButton(
// //                       onPressed: ajouterVisite,
// //                       child: const Text("Ajouter une visite"),
// //                     ),
// //                     const SizedBox(height: 20),

// //                     // Liste des visites
// //                     const Text(
// //                       "Historique des Visites",
// //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     ...visites.map((visite) {
// //                       DateTime visitDate =
// //                           DateTime.parse(visite['date']).toLocal();
// //                       return Card(
// //                         child: ListTile(
// //                           title: Text("Visite prévue : $visitDate"),
// //                           subtitle: const Text("Date de la visite"),
// //                         ),
// //                       );
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class SuiviEtatNutritionnelPage extends StatefulWidget {
//   final String enfantId;

//   const SuiviEtatNutritionnelPage({super.key, required this.enfantId});

//   @override
//   State<SuiviEtatNutritionnelPage> createState() =>
//       _SuiviEtatNutritionnelPageState();
// }

// class _SuiviEtatNutritionnelPageState extends State<SuiviEtatNutritionnelPage> {
//   final supabase = Supabase.instance.client;

//   DateTime selectedDate = DateTime.now();
//   List<Map<String, dynamic>> visites = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     tz.initializeTimeZones(); // Initialise les fuseaux horaires
//     fetchSuiviData();
//   }

//   /// Récupération des visites depuis Supabase
//   Future<void> fetchSuiviData() async {
//     try {
//       final response = await supabase
//           .from('suivi')
//           .select()
//           .eq('enfant_id', widget.enfantId)
//           .order('date', ascending: true);

//       setState(() {
//         visites = response;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Erreur lors du chargement des données.")),
//       );
//     }
//   }

//   /// Programmation de notifications
//   Future<void> programmerNotification(DateTime dateVisite) async {
//     final notificationPlugin = FlutterLocalNotificationsPlugin();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'visites_channel',
//       'Visites prévues',
//       channelDescription: 'Rappels pour les visites prévues',
//       importance: Importance.high,
//       priority: Priority.high,
//       icon: 'notification_icon',
//     );

//     const NotificationDetails platformDetails =
//         NotificationDetails(android: androidDetails);

//     // await notificationPlugin.zonedSchedule(
//     //   dateVisite.millisecondsSinceEpoch ~/ 1000,
//     //   'Rappel de visite',
//     //   'Une visite est prévue le ${dateVisite.toLocal()}',
//     //   tz.TZDateTime.from(dateVisite, tz.local),
//     //   platformDetails,
//     //   // androidAllowWhileIdle: true,
//     //   uiLocalNotificationDateInterpretation:
//     //       UILocalNotificationDateInterpretation.absoluteTime, androidScheduleMode: null,
//     // );
//   }

//   /// Ajoute une visite automatique après chaque réalisation
//   Future<void> ajouterVisiteAutomatique(DateTime derniereVisite) async {
//     try {
//       final DateTime prochaineVisite =
//           derniereVisite.add(const Duration(days: 14));

//       // Ajouter une notification pour la prochaine visite
//       await programmerNotification(prochaineVisite);

//       await supabase.from('suivi').insert({
//         'enfant_id': widget.enfantId,
//         'date': prochaineVisite.toIso8601String(),
//         'status': 'À venir',
//       });

//       fetchSuiviData(); // Recharge les données
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Erreur lors de l'ajout de la visite.")),
//       );
//     }
//   }

//   /// Marque une visite comme réalisée
//   Future<void> marquerVisiteRealisee(Map<String, dynamic> visite) async {
//     try {
//       await supabase
//           .from('suivi')
//           .update({'status': 'Réalisée'})
//           .eq('id', visite['id']);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Visite marquée comme réalisée.")),
//       );

//       // Ajout de la visite suivante automatiquement
//       ajouterVisiteAutomatique(DateTime.parse(visite['date']));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Erreur lors de la mise à jour de la visite.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Suivi de l'État Nutritionnel"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Calendrier des Visites",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),

//                     // Table Calendar
//                     TableCalendar(
//                       focusedDay: selectedDate,
//                       firstDay: DateTime.utc(2020, 1, 1),
//                       lastDay: DateTime.utc(2025, 12, 31),
//                       selectedDayPredicate: (day) {
//                         return isSameDay(day, selectedDate);
//                       },
//                       onDaySelected: (selectedDay, focusedDay) {
//                         setState(() {
//                           selectedDate = selectedDay;
//                         });
//                       },
//                       calendarBuilders: CalendarBuilders(
//                         defaultBuilder: (context, day, focusedDay) {
//                           final visitesDates = visites
//                               .map((visite) => DateTime.parse(visite['date']))
//                               .toList();

//                           if (visitesDates.contains(day)) {
//                             final visite = visites.firstWhere(
//                                 (visite) =>
//                                     DateTime.parse(visite['date'])
//                                         .isAtSameMomentAs(day),
//                                 orElse: () => {});

//                             if (visite['status'] == 'Réalisée') {
//                               return Container(
//                                 margin: const EdgeInsets.all(4.0),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.green,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '${day.day}',
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               );
//                             } else if (visite['status'] == 'À venir') {
//                               return Container(
//                                 margin: const EdgeInsets.all(4.0),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.orange,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '${day.day}',
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               );
//                             }
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Liste des visites
//                     const Text(
//                       "Visites prévues",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     ...visites
//                         .where((visite) =>
//                             DateTime.parse(visite['date']).isAfter(
//                                 DateTime.now()) &&
//                             visite['status'] == 'À venir')
//                         .map((visite) {
//                       return Card(
//                         child: ListTile(
//                           title: Text(
//                               "Date : ${DateTime.parse(visite['date']).toLocal()}"),
//                           subtitle: Text("Statut : ${visite['status']}"),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.check_circle),
//                             color: Colors.green,
//                             onPressed: () => marquerVisiteRealisee(visite),
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

import '../../models/visite.dart';

class SuiviEtatNutritionnelPage extends StatefulWidget {
  final String enfantId;

  const SuiviEtatNutritionnelPage({Key? key, required this.enfantId})
      : super(key: key);

  @override
  State<SuiviEtatNutritionnelPage> createState() =>
      _SuiviEtatNutritionnelPageState();
}

class _SuiviEtatNutritionnelPageState extends State<SuiviEtatNutritionnelPage> {
  final supabase = Supabase.instance.client;

  DateTime selectedDate = DateTime.now();
  List<Visite> visites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    fetchVisites();
  }

  /// Récupère les visites depuis Supabase
  Future<void> fetchVisites() async {
    try {
      final response = await supabase
          .from('visites')
          .select()
          .eq('enfant_id', widget.enfantId)
          .order('date', ascending: true);

      setState(() {
        visites = response.map((v) => Visite.fromJson(v)).toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du chargement des visites.")),
      );
    }
  }

  /// Programme une notification pour une visite
  Future<void> programmerNotification(DateTime dateVisite) async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'visites_channel',
      'Rappels de visites',
      channelDescription: 'Notifications pour les visites prévues',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    // await notificationPlugin.zonedSchedule(
    //   dateVisite.millisecondsSinceEpoch ~/ 1000,
    //   'Rappel de visite',
    //   'Une visite est prévue le ${dateVisite.toLocal()}',
    //   tz.TZDateTime.from(dateVisite, tz.local),
    //   platformDetails,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }

  /// Ajoute une visite bihebdomadaire
  Future<void> ajouterVisite(DateTime derniereVisite) async {
    try {
      final prochaineVisite = derniereVisite.add(const Duration(days: 14));
      /// TODO Ajout de idType
      await supabase.from('visites').insert({
        'enfant_id': widget.enfantId,
        'date': prochaineVisite.toIso8601String(),
        'status': 'À venir',
      });

      await programmerNotification(prochaineVisite);
      fetchVisites();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'ajout de la visite.")),
      );
    }
  }

  /// Marque une visite comme réalisée
  Future<void> marquerVisiteRealisee(Visite visite) async {
    try {
      await supabase
          .from('visites')
          .update({'status': 'Réalisée'}).eq('id', visite.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Visite marquée comme réalisée.")),
      );

      ajouterVisite(visite.date);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Erreur lors de la mise à jour de la visite.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suivi Bihebdomadaire"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Calendrier des Visites",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TableCalendar(
                    focusedDay: selectedDate,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final visite = visites.firstWhere(
                          (v) => v.date.isAtSameMomentAs(day),
                          orElse: () => Visite(
                            id: 'null',
                            enfantId: '',
                            date: DateTime.now(),
                            status: '',
                            idDepistage: '',
                            type: '',
                            idType: '',
                          ),
                        );

                        if (visite.id != "null") {
                          final color = visite.status == 'Réalisée'
                              ? Colors.green
                              : (visite.status == 'À venir'
                                  ? Colors.orange
                                  : Colors.red);

                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
