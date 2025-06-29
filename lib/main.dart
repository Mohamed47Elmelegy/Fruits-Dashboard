import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'core/Routes/page_routes_name.dart';
import 'core/Routes/routes.dart';
import 'core/services/bloc_observer_service.dart';
import 'core/services/get_it_services.dart';
import 'core/services/supabase_init_service.dart';
import 'core/services/supabase_test_service.dart';
import 'core/services/enhanced_firestore_service.dart';
import 'core/services/initial_data_service.dart';
import 'core/services/firebase_status_service.dart';
import 'core/theme/application_theme_manager.dart';
import 'core/config/ansicolor.dart';
import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Test Firebase connection
Future<void> testFirebaseConnection() async {
  try {
    DebugConsoleMessages.info('🔍 Testing Firebase connection...');

    // Test Firestore connection
    final testDoc = await FirebaseFirestore.instance.collection('test').add({
      'test': 'connection',
      'timestamp': FieldValue.serverTimestamp(),
      'platform': 'iOS',
      'appVersion': '1.0.5'
    });

    DebugConsoleMessages.success(
        '✅ Firestore connection successful: ${testDoc.id}');

    // Clean up test document
    await testDoc.delete();
    DebugConsoleMessages.info('🧹 Test document cleaned up');
  } catch (e) {
    DebugConsoleMessages.error('❌ Firebase connection test failed: $e');
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    DebugConsoleMessages.info('🚀 Starting app initialization...');

    Bloc.observer = BlocObserverService();

    DebugConsoleMessages.info('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DebugConsoleMessages.success('✅ Firebase initialized successfully');

    // Test Firebase connection
    await testFirebaseConnection();

    // Initialize enhanced Firestore service
    DebugConsoleMessages.info('📊 Initializing enhanced Firestore service...');
    await EnhancedFirestoreService.initialize();
    DebugConsoleMessages.success('✅ Enhanced Firestore service initialized');

    // Initialize Supabase using the service
    DebugConsoleMessages.info('🔄 Initializing Supabase...');
    await SupabaseInitService.initialize();
    DebugConsoleMessages.success('✅ Supabase initialized successfully');

    // Test Supabase functionality
    await SupabaseTestService.runAllTests();

    // تسجيل دخول admin مؤقتاً (استبدل البيانات ببيانات حسابك)
    DebugConsoleMessages.info('🔐 Signing in admin...');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'mohamed@gmail.com', // ضع هنا بريد الأدمن
      password: 'password', // ضع هنا كلمة مرور الأدمن
    );
    DebugConsoleMessages.success('✅ Admin signed in successfully');

    // Initialize app data structures
    DebugConsoleMessages.info('📊 Initializing app data structures...');
    await InitialDataService.initializeAppData();
    DebugConsoleMessages.success('✅ App data structures initialized');

    DebugConsoleMessages.info('⚙️ Setting up dependency injection...');
    setupGetit();
    DebugConsoleMessages.success('✅ Dependency injection setup complete');

    // Print comprehensive Firebase status report
    await FirebaseStatusService.printFirebaseStatus();

    DebugConsoleMessages.success('🎉 App initialization complete!');
    runApp(const FruitAppDashBord());
  } catch (e) {
    DebugConsoleMessages.error('❌ Error during app initialization: $e');
    // Still run the app but with error state
    runApp(const FruitAppDashBord());
  }
}

class FruitAppDashBord extends StatelessWidget {
  const FruitAppDashBord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(
        builder: BotToastInit(),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: PageRoutesName.initial,
      navigatorKey: navigatorKey,
      theme: ApplicationThemeManager.applicationThemeData,
    );
  }
}
