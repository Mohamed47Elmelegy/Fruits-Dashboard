import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/models/app_settings.dart';
import '../../../../core/services/app_settings_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  AppSettings? settings;
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  final _formKey = GlobalKey<FormState>();
  final AppSettingsService _service = AppSettingsService();

  Future<void> fetchSettings() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      settings = await _service.fetchSettings();
    } catch (e) {
      error = 'حدث خطأ أثناء جلب البيانات';
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isSaving = true;
      error = null;
    });
    try {
      await _service.saveSettings(settings!);
    } catch (e) {
      error = 'حدث خطأ أثناء الحفظ';
    }
    setState(() {
      isSaving = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : settings == null
              ? Center(child: Text(error ?? 'لا توجد بيانات'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: settings!.appName,
                          decoration:
                              const InputDecoration(labelText: 'اسم التطبيق'),
                          onChanged: (v) => settings!.appName = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          initialValue: settings!.version,
                          decoration:
                              const InputDecoration(labelText: 'الإصدار'),
                          onChanged: (v) => settings!.version = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          initialValue: settings!.currency,
                          decoration:
                              const InputDecoration(labelText: 'العملة'),
                          onChanged: (v) => settings!.currency = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          initialValue: settings!.deliveryFee.toString(),
                          decoration:
                              const InputDecoration(labelText: 'رسوم التوصيل'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              settings!.deliveryFee = double.tryParse(v) ?? 0,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          initialValue: settings!.minOrderAmount.toString(),
                          decoration: const InputDecoration(
                              labelText: 'الحد الأدنى للطلب'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => settings!.minOrderAmount =
                              double.tryParse(v) ?? 0,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        SwitchListTile(
                          title: const Text('وضع الصيانة'),
                          value: settings!.maintenanceMode,
                          onChanged: (v) =>
                              setState(() => settings!.maintenanceMode = v),
                        ),
                        const Gap(16),
                        TextFormField(
                          initialValue: settings!.supportEmail,
                          decoration:
                              const InputDecoration(labelText: 'البريد للدعم'),
                          onChanged: (v) => settings!.supportEmail = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          initialValue: settings!.supportPhone,
                          decoration:
                              const InputDecoration(labelText: 'هاتف الدعم'),
                          onChanged: (v) => settings!.supportPhone = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        const Gap(16),
                        if (error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(error!,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ElevatedButton(
                          onPressed: isSaving ? null : saveSettings,
                          child: isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Text('حفظ التعديلات'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: isSaving ? null : fetchSettings,
                          child: const Text('إعادة تحميل من السحابة'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
