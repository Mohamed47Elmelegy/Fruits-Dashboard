import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/constants.dart';
import '../config/ansicolor.dart';

class SupabaseInitService {
  static bool _isInitialized = false;

  /// Initialize Supabase with proper error handling
  static Future<void> initialize() async {
    if (_isInitialized) {
      DebugConsoleMessages.info('ℹ️ Supabase already initialized');
      return;
    }

    try {
      DebugConsoleMessages.info('🔄 Initializing Supabase...');

      await Supabase.initialize(
        url: Constatns.supabaseUrl,
        anonKey: Constatns.supabaseKey,
      );

      _isInitialized = true;
      DebugConsoleMessages.success('✅ Supabase initialized successfully');
    } catch (e) {
      DebugConsoleMessages.error('❌ Error initializing Supabase: $e');
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  /// Get Supabase client safely
  static SupabaseClient getClient() {
    if (!_isInitialized) {
      throw Exception(
          'Supabase not initialized. Call SupabaseInitService.initialize() first.');
    }
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Failed to get Supabase client: $e');
    }
  }

  /// Check if Supabase is initialized
  static bool get isInitialized => _isInitialized;
}
