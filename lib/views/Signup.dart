import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../fitness_store.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key, this.onBack});

  static String routeName = 'Signup';
  static String routePath = '/signup';

  final VoidCallback? onBack;

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _initialWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _goalController = TextEditingController();

  bool _didSeedInitialValues = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didSeedInitialValues) {
      return;
    }

    final profile = context.read<FitnessStore>().profile;
    final source = profile ?? AppData.seedProfile;

    _nameController.text = source.name;
    _heightController.text = source.heightCm.toStringAsFixed(0);
    _initialWeightController.text = source.initialWeightKg.toStringAsFixed(1);
    _targetWeightController.text = source.targetWeightKg.toStringAsFixed(1);
    _goalController.text = '${source.activityGoalPerWeek}';
    _didSeedInitialValues = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _initialWeightController.dispose();
    _targetWeightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.chevron_left_rounded),
                        tooltip: 'Back',
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Profile Setup',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Isi profil dasar Anda untuk personalisasi ringkasan fitness tracker.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _AppTextField(
                    controller: _nameController,
                    label: 'Nama user',
                    hintText: 'Contoh: Rizlrad',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _AppTextField(
                          controller: _heightController,
                          label: 'Tinggi (cm)',
                          hintText: '171',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final number = double.tryParse(value?.trim() ?? '');
                            if (number == null || number <= 0) {
                              return 'Tinggi tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AppTextField(
                          controller: _goalController,
                          label: 'Goal / minggu',
                          hintText: '4',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final number = int.tryParse(value?.trim() ?? '');
                            if (number == null || number <= 0) {
                              return 'Goal tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _AppTextField(
                          controller: _initialWeightController,
                          label: 'Berat awal (kg)',
                          hintText: '72.0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            final number = double.tryParse(value?.trim() ?? '');
                            if (number == null || number <= 0) {
                              return 'Berat awal tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AppTextField(
                          controller: _targetWeightController,
                          label: 'Target berat (kg)',
                          hintText: '69.0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            final number = double.tryParse(value?.trim() ?? '');
                            if (number == null || number <= 0) {
                              return 'Target tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Simpan profil'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Setelah profil disimpan, Anda bisa pindah ke tab Body Progress untuk mencatat berat terbaru.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667085),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      border: Border.all(color: const Color(0xFFFECACA)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danger zone',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF991B1B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Reset akan menghapus semua data profil, body progress, workout, dan workout log yang tersimpan.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF7F1D1D),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _resetAllData,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB91C1C),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                          ),
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text('Reset semua data'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final profile = UserProfile(
      name: _nameController.text.trim(),
      heightCm: double.parse(_heightController.text.trim()),
      targetWeightKg: double.parse(_targetWeightController.text.trim()),
      activityGoalPerWeek: int.parse(_goalController.text.trim()),
      initialWeightKg: double.parse(_initialWeightController.text.trim()),
    );

    await context.read<FitnessStore>().saveProfile(profile);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan.')),
    );
  }

  Future<void> _resetAllData() async {
    FocusScope.of(context).unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset semua data?'),
          content: const Text(
            'Tindakan ini akan menghapus seluruh data profile, body progress, workout, dan workout log yang tersimpan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              child: const Text('Ya, reset'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await context.read<FitnessStore>().resetAllData();

    if (!mounted) {
      return;
    }

    _nameController.clear();
    _heightController.clear();
    _initialWeightController.clear();
    _targetWeightController.clear();
    _goalController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua data berhasil direset.')),
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
