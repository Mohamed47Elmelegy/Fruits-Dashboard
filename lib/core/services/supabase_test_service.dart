import '../constants/constants.dart';
import '../config/ansicolor.dart';
import 'supabase_init_service.dart';

class SupabaseTestService {
  /// Test Supabase storage functionality
  static Future<bool> testStorageConnection() async {
    try {
      DebugConsoleMessages.info('🧪 Testing Supabase storage connection...');

      final client = SupabaseInitService.getClient();

      // Test bucket access
      final buckets = await client.storage.listBuckets();
      DebugConsoleMessages.info(
          '📦 Available buckets: ${buckets.map((b) => b.name).join(', ')}');

      // Check if our bucket exists
      final hasBucket =
          buckets.any((bucket) => bucket.name == Constatns.supabaseBucket);

      if (hasBucket) {
        DebugConsoleMessages.success(
            '✅ Bucket "${Constatns.supabaseBucket}" found');
        return true;
      } else {
        DebugConsoleMessages.warning(
            '⚠️ Bucket "${Constatns.supabaseBucket}" not found');
        DebugConsoleMessages.info(
            '💡 Available buckets: ${buckets.map((b) => b.name).join(', ')}');
        return false;
      }
    } catch (e) {
      DebugConsoleMessages.error('❌ Supabase storage test failed: $e');
      return false;
    }
  }

  /// Test Supabase client access
  static Future<bool> testClientAccess() async {
    try {
      DebugConsoleMessages.info('🧪 Testing Supabase client access...');

      SupabaseInitService.getClient();

      // Simple test - just check if we can access the client
      DebugConsoleMessages.success('✅ Supabase client accessible');

      return true;
    } catch (e) {
      DebugConsoleMessages.error('❌ Supabase client test failed: $e');
      return false;
    }
  }

  /// Run all tests
  static Future<void> runAllTests() async {
    DebugConsoleMessages.info('🧪 Running Supabase tests...');

    final clientTest = await testClientAccess();
    final storageTest = await testStorageConnection();

    if (clientTest && storageTest) {
      DebugConsoleMessages.success('✅ All Supabase tests passed!');
    } else {
      DebugConsoleMessages.warning('⚠️ Some Supabase tests failed');
    }
  }
}
