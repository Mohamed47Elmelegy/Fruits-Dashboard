import 'package:flutter/material.dart';

import '../../main.dart';

class Constants {
  static var mediaQuery = MediaQuery.sizeOf(
    navigatorKey.currentState!.context,
  );
  static var theme = Theme.of(
    navigatorKey.currentState!.context,
  );
  static const supabaseUrl = 'https://cgviejtxuekjoqccyyfg.supabase.co';
  static const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNndmllanR4dWVram9xY2N5eWZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMwODEyMzYsImV4cCI6MjA0ODY1NzIzNn0.22LQ6dS_4uDzxP-J8UZDeWUOMiZBz3dhrWQJObRknzY';
  static const imgaeBucket = 'fruits_images';
}
