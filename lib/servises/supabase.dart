// import 'package:supabase_flutter/supabase_flutter.dart';

// class SupabaseService {
//   final SupabaseClient client = Supabase.instance.client;

//   Future<void> syncToCloud(String table, Map<String, dynamic> data) async {
//     final response = await client.from(table).upsert(data);
//     if (response.error != null) {
//       throw Exception("Erreur de synchronisation : ${response.error!.message}");
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchFromCloud(String table) async {
//     final response = await client.from(table).select();
//     if (response != null) {
//       throw Exception("Erreur de récupération : $response");
//     }
//     return List<Map<String, dynamic>>.from(response);
//   }
// }
