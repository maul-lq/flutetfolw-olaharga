import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _phoneController = TextEditingController();

  static const List<_CountryOption> _countryOptions = [
    _CountryOption(code: '+1', label: 'United States'),
    _CountryOption(code: '+62', label: 'Indonesia'),
    _CountryOption(code: '+90', label: 'Turkey'),
    _CountryOption(code: '+46', label: 'Sweden'),
  ];

  String _selectedCode = _countryOptions.first.code;

  bool get _canSend => _phoneController.text.trim().length >= 7;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_handleFieldChange);
  }

  @override
  void dispose() {
    _phoneController
      ..removeListener(_handleFieldChange)
      ..dispose();
    super.dispose();
  }

  void _handleFieldChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _sendConfirmationCode() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phoneNumber = '$_selectedCode ${_phoneController.text.trim()}';
    final greetingName = widget.firstName?.trim().isNotEmpty == true
        ? widget.firstName!.trim()
        : 'there';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Confirmation code sent to $phoneNumber for $greetingName.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasProfileSummary = (widget.firstName?.trim().isNotEmpty ?? false) ||
        (widget.email?.trim().isNotEmpty ?? false);

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
                      onPressed: widget.onBack ??
                          () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: 'Back',
                    ),
                    const Expanded(
                      child: Text(
                        'Complete account setup',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F1FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.sms_outlined,
                          color: colorScheme.primary,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Verify your phone number',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'To finish setting up your account, we\'ll need to send you a confirmation code.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF667085),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasProfileSummary) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD0D5DD)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account summary',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101828),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (widget.firstName?.trim().isNotEmpty ?? false)
                          Text(
                            'First name: ${widget.firstName!.trim()}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        if (widget.email?.trim().isNotEmpty ?? false)
                          Padding(
                            padding: EdgeInsets.only(
                              top:
                                  (widget.firstName?.trim().isNotEmpty ?? false)
                                      ? 6
                                      : 0,
                            ),
                            child: Text(
                              'Email: ${widget.email!.trim()}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101828),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masukkan kode negara dan nomor ponsel aktif untuk menerima kode konfirmasi.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF667085),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 420;
                            final codeField = DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _selectedCode,
                              decoration: _inputDecoration(
                                context,
                                label: 'Code',
                              ),
                              items: _countryOptions
                                  .map(
                                    (option) => DropdownMenuItem<String>(
                                      value: option.code,
                                      child: Text(
                                        option.code,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedCode = value;
                                });
                              },
                            );

                            final phoneField = TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _inputDecoration(
                                context,
                                label: 'Phone number',
                                hintText: '81234567890',
                              ),
                              validator: (value) {
                                final digits = value?.trim() ?? '';
                                if (digits.isEmpty) {
                                  return 'Phone number wajib diisi';
                                }
                                if (digits.length < 7) {
                                  return 'Phone number minimal 7 digit';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                if (_canSend) {
                                  _sendConfirmationCode();
                                }
                              },
                            );

                            if (!isWide) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: codeField,
                                  ),
                                  const SizedBox(height: 16),
                                  phoneField,
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 4, child: codeField),
                                const SizedBox(width: 16),
                                Expanded(flex: 7, child: phoneField),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _canSend ? _sendConfirmationCode : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              disabledBackgroundColor: const Color(0xFFE4E7EC),
                              disabledForegroundColor: const Color(0xFF98A2B3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Send confirmation code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'By providing your phone number, you agree that it may be used to send you text messages about reservation changes. Standard message and data rates may apply. You can contact us or reply STOP to the text to opt out.',
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

class _CountryOption {
  const _CountryOption({
    required this.code,
    required this.label,
  });

  final String code;
  final String label;
}
