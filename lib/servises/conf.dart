import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://oqwckiifdcqdkvueszhr.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xd2NraWlmZGNxZGt2dWVzemhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxMzg1MTMsImV4cCI6MjA0ODcxNDUxM30.oybmBBmDcUmFYzTcOdXDAJ24U1gqEYSoj5L4KyHz8D8';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
