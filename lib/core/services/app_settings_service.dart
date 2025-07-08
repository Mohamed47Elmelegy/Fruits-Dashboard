import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_settings.dart';

class AppSettingsService {
  final _docRef =
      FirebaseFirestore.instance.collection('appSettings').doc('general');

  Future<AppSettings?> fetchSettings() async {
    final doc = await _docRef.get();
    if (doc.exists) {
      return AppSettings.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _docRef.set(settings.toMap());
  }
}
