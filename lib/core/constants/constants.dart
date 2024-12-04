import 'package:flutter/material.dart';

import '../../main.dart';

class Constatns {
  static var mediaQuery = MediaQuery.sizeOf(
    navigatorKey.currentState!.context,
  );
  static var theme = Theme.of(
    navigatorKey.currentState!.context,
  );
  static const supabaseUrl = 'https://jhkvhvqdwhvcyssralfz.supabase.co';
  static const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impoa3ZodnFkd2h2Y3lzc3JhbGZ6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMzA5MzEyMCwiZXhwIjoyMDQ4NjY5MTIwfQ.xaFrkegMR7fbsqgeqb0cna1T3pJyaI2aWtcghUI1Xkc';
  static const supabaseBucket = 'fruits_images';
}
