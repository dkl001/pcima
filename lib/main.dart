import 'package:flutter/material.dart';
import 'package:pcima/screens/home.dart';

// import 'models/nutrition.dart';
// import 'screens/mam/add.dart';
import 'screens/critere_admission.dart';
// import 'screens/decharge.dart';
import 'screens/mam/echec_form.dart';
import 'screens/protocole.dart';
import 'screens/suivie.dart';
import 'screens/supplementation.dart';
import 'servises/conf.dart';

// import 'screens/add_patient.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Configuration des notifications locales
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  SupabaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  const HomeScreen(),
        '/protocol': (context) => ProtocoleScreen(),
        // '/addPatient': (context) => const AddPatientScreen(),
        '/admission': (context) => const AdmissionCriteriaScreen(),
        '/supplementation': (context) => SupplementationScreen(),
        '/suivie': (context) => NutritionFollowUpScreen(),
        '/echec': (context) => const FailureManagementScreen(patientId: 7, patientName: 'e'),
        // '/decharge': (context) => DischargeCriteriaScreen(
        //       patient: NutritionCase(
        //         id: 1,
        //         patientName: 'Jean Dupont',
        //         ageMonths: 36,
        //         muac: 126,
        //         weight: 12.0,
        //         height: 1.0,
        //         hasEdema: false,
        //         edemaSeverity: 'Non spécifié',
        //         admissionType: 'Nouvelle Admission',
        //         status: 'Actif',
        //         admissionDate: DateTime.now(),
        //         isVaccinated: true,
        //       ),
        //  ),
      },
      // home: HomeScreen(),
    );
  }
}


// -----------------------------------------------------------------------------------------------------



// import 'package:flutter/material.dart';
// import 'screens/critere_admission.dart';
// import 'screens/suivie.dart';
// import 'screens/supplementation.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Gestion MAM')),
//         body: ListView(
//           children: [
//             ListTile(
//               title: const Text('Critères d\'Admission'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AdmissionCriteriaScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Supplémentation Nutritionnelle'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SupplementationScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Suivi Nutritionnel'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => NutritionFollowUpScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ----------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// import 'models/nutrition.dart';
// import 'screens/add.dart';
// import 'screens/list_patient.dart';
// import 'screens/critere_admission.dart';
// import 'screens/decharge.dart';
// import 'screens/echec.dart';
// import 'screens/stat.dart';
// import 'screens/suivie.dart';
// import 'screens/supplementation.dart';
// import 'servises/conf.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SupabaseConfig.initialize();
//   // await SupabaseService().syncUnsyncedPatients();
//   runApp(const MyApp());
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const MainMenuScreen(),
//         '/addPatient': (context) => const AddPatientScreen(),
//         '/admission': (context) => const AdmissionCriteriaScreen(),
//         '/supplementation': (context) => SupplementationScreen(),
//         '/suivie': (context) => NutritionFollowUpScreen(),
//         '/echec': (context) => const FailureManagementScreen(patientId: 7, patientName: 'e'),
//         '/decharge': (context) => DischargeCriteriaScreen(
//               patient: NutritionCase(
//                 id: 1,
//                 patientName: 'Jean Dupont',
//                 ageMonths: 36,
//                 muac: 126,
//                 weight: 12.0,
//                 height: 1.0,
//                 hasEdema: false,
//                 edemaSeverity: 'Non spécifié',
//                 admissionType: 'Nouvelle Admission',
//                 status: 'Actif',
//                 admissionDate: DateTime.now(),
//                 isVaccinated: true,
//               ),
//             ),
//       },
//     );
//   }
// }

// class MainMenuScreen extends StatelessWidget {
//   const MainMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Gestion MAM')),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Ajout patient'),
//             onTap: () {
//               Navigator.pushNamed(context, '/addPatient');
//             },
//           ),
//           ListTile(
//             title: const Text('Critères d\'Admission'),
//             onTap: () {
//               Navigator.pushNamed(context, '/admission');
//             },
//           ),
//           ListTile(
//             title: const Text('Supplémentation Nutritionnelle'),
//             onTap: () {
//               Navigator.pushNamed(context, '/supplementation');
//             },
//           ),
//           ListTile(
//             title: const Text('Suivi Nutritionnel'),
//             onTap: () {
//               Navigator.pushNamed(context, '/suivie');
//             },
//           ),
//           ListTile(
//             title: const Text('Échecs de Traitement'),
//             onTap: () {
//               Navigator.pushNamed(context, '/echec');
//             },
//           ),
//           ListTile(
//             title: const Text('Critères de Sortie'),
//             onTap: () {
//               Navigator.pushNamed(context, '/decharge');
//             },
//           ),
//           ListTile(
//             title: const Text('Statistiques du Programme'),
//             onTap: () {
//               // Ajoutez le code de navigation ici si nécessaire.
//             },
//           ),
//           ListTile(
//   title: const Text('Liste des Patients'),
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const PatientsListScreen()),
//     );
//   },
// ),
// ListTile(
//   title: const Text('Statistiques'),
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => StatisticsScreen()),
//     );
//   },
// ),

//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter_test/flutter_test.dart';

// import 'screen1.dart/depistage.dart';

// void main() {
//   test('Tri automatique selon les critères', () {
//     expect(effectuerTri(114, '++'), 'CRENI');
//     expect(effectuerTri(120, 'Absence'), 'CRENAM');
//     expect(effectuerTri(126, 'Absence'), 'Normal');
//   });
// }
