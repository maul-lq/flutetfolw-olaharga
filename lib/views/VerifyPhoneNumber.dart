import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../fitness_store.dart';

class VerifyPhoneNumberWidget extends StatefulWidget {
  const VerifyPhoneNumberWidget({
    super.key,
    this.firstName,
    this.email,
    this.onBack,
  });

  final String? firstName;
  final String? email;
  final VoidCallback? onBack;

  static String routeName = 'VerifyPhoneNumber';
  static String routePath = '/verifyPhoneNumber';

  @override
  State<VerifyPhoneNumberWidget> createState() =>
      _VerifyPhoneNumberWidgetState();
}

class _VerifyPhoneNumberWidgetState extends State<VerifyPhoneNumberWidget> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _didSeedInitialValues = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didSeedInitialValues) {
      return;
    }

    final store = context.read<FitnessStore>();
    final latestMetric = store.latestBodyMetric;
    final profile = store.profile;

    if (latestMetric != null) {
      _weightController.text = latestMetric.weightKg.toStringAsFixed(1);
      _heightController.text = latestMetric.heightCm.toStringAsFixed(0);
    } else if (profile != null) {
      _weightController.text = profile.initialWeightKg.toStringAsFixed(1);
      _heightController.text = profile.heightCm.toStringAsFixed(0);
    } else {
      _heightController.text = '170';
    }

    _didSeedInitialValues = true;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.watch<FitnessStore>();
    final latestMetric = store.latestBodyMetric;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          widget.onBack ?? () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Body Progress Entry',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Catat berat dan tinggi tubuh terbaru untuk melihat tren progress di dashboard.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 14),
                if (latestMetric != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.insights_outlined),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Entry terakhir: ${latestMetric.weightKg.toStringAsFixed(1)} kg · ${formatWorkoutDate(latestMetric.date)}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data tubuh',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: _inputDecoration(
                                    context,
                                    label: 'Berat (kg)',
                                    hintText: '71.8',
                                  ),
                                  validator: (value) {
                                    final number =
                                        double.tryParse(value?.trim() ?? '');
                                    if (number == null || number <= 0) {
                                      return 'Berat tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: _inputDecoration(
                                    context,
                                    label: 'Tinggi (cm)',
                                    hintText: '171',
                                  ),
                                  validator: (value) {
                                    final number =
                                        double.tryParse(value?.trim() ?? '');
                                    if (number == null || number <= 0) {
                                      return 'Tinggi tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(formatWorkoutDate(_selectedDate)),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _noteController,
                            minLines: 3,
                            maxLines: 5,
                            decoration: _inputDecoration(
                              context,
                              label: 'Catatan (opsional)',
                              hintText:
                                  'Contoh: tidur lebih cukup, latihan terasa lebih ringan.',
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _saveEntry,
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('Simpan progress tubuh'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  Future<void> _saveEntry() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final entry = BodyMetricEntry(
      id: 'metric-${DateTime.now().microsecondsSinceEpoch}',
      date: _selectedDate,
      weightKg: double.parse(_weightController.text.trim()),
      heightCm: double.parse(_heightController.text.trim()),
      note: _noteController.text.trim(),
    );

    await context.read<FitnessStore>().addBodyMetric(entry);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Body progress berhasil disimpan.')),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String label,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD92D20)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD92D20)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
