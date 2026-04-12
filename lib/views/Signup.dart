import 'package:flutter/material.dart';

import 'VerifyPhoneNumber.dart';

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  static final RegExp _emailPattern =
      RegExp('^[^@\\s]+@[^@\\s]+\\.[^@\\s]+', caseSensitive: false);

  bool get _canSubmit {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _emailPattern.hasMatch(_emailController.text.trim());
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_handleFieldChange);
    _lastNameController.addListener(_handleFieldChange);
    _emailController.addListener(_handleFieldChange);
  }

  @override
  void dispose() {
    _firstNameController
      ..removeListener(_handleFieldChange)
      ..dispose();
    _lastNameController
      ..removeListener(_handleFieldChange)
      ..dispose();
    _emailController
      ..removeListener(_handleFieldChange)
      ..dispose();
    super.dispose();
  }

  void _handleFieldChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showComingSoon(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider sign-up belum tersedia di build ini.'),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VerifyPhoneNumberWidget(
          firstName: _firstNameController.text.trim(),
          email: _emailController.text.trim(),
        ),
      ),
    );
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed:
                      widget.onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.chevron_left_rounded),
                  tooltip: 'Back',
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _showComingSoon('Apple'),
                  icon: const Icon(Icons.apple),
                  label: const Text('Continue with Apple'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 54),
                    side: const BorderSide(color: Color(0xFF111827)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'If you sign up through Apple, you agree to the Terms of Use and Privacy Notice.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667085),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 440;
                          final firstNameField = _AppTextField(
                            controller: _firstNameController,
                            label: 'First name',
                            hintText: 'First name',
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'First name wajib diisi';
                              }
                              return null;
                            },
                          );
                          final lastNameField = _AppTextField(
                            controller: _lastNameController,
                            label: 'Last name',
                            hintText: 'Last name',
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Last name wajib diisi';
                              }
                              return null;
                            },
                          );

                          if (!isWide) {
                            return Column(
                              children: [
                                firstNameField,
                                const SizedBox(height: 16),
                                lastNameField,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: firstNameField),
                              const SizedBox(width: 16),
                              Expanded(child: lastNameField),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _AppTextField(
                        controller: _emailController,
                        label: 'Email address',
                        hintText: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!_emailPattern.hasMatch(email)) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                        onSubmitted: (_) {
                          if (_canSubmit) {
                            _submit();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            backgroundColor: const Color(0xFFE5E7EB),
                            foregroundColor: const Color(0xFF9CA3AF),
                            disabledBackgroundColor: const Color(0xFFE5E7EB),
                            disabledForegroundColor: const Color(0xFF9CA3AF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Sign up'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'By signing up you agree to our Terms of Use and Privacy Notice.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667085),
                      height: 1.5,
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
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
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
