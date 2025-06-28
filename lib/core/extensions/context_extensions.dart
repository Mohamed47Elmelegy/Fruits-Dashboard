import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtensions on BuildContext {
  /// Safely reads a cubit from context, returns null if not found
  T? tryRead<T extends BlocBase>() {
    try {
      return read<T>();
    } catch (e) {
      return null;
    }
  }

  /// Safely reads a cubit from context, throws if not found
  T safeRead<T extends BlocBase>() {
    try {
      return read<T>();
    } catch (e) {
      throw Exception('Cubit of type $T not found in context');
    }
  }
}
