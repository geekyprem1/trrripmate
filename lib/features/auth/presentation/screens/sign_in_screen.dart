import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/validators.dart';
import 'package:tripmate/features/auth/presentation/controllers/sign_in_controller.dart';

enum _AuthMode { email, phone }

/// Sign In screen — Google, Apple, Email, Phone (UI/UX §3.2, PRD REQ-AUTH-01).
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  _AuthMode _mode = _AuthMode.email;
  bool _isRegister = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  SignInController get _controller =>
      ref.read(signInControllerProvider.notifier);

  Future<void> _submitEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_isRegister) {
      await _controller.signUpWithEmail(email, password);
    } else {
      await _controller.signInWithEmail(email, password);
    }
  }

  Future<void> _submitPhone() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = _phoneController.text.trim();
    final sent = await _controller.requestPhoneOtp(phone);
    if (sent && mounted) {
      unawaited(
        context.pushNamed(AppRoutes.otpName, extra: OtpArgs(phone: phone)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(signInControllerProvider);
    final isLoading = state.isLoading;
    final isIos = theme.platform == TargetPlatform.iOS;

    ref.listen(signInControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        final message =
            error is Failure ? error.displayMessage : 'Something went wrong.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.travel_explore,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'TripMate',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      'Travel Together. Split Smarter.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _SocialButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      onPressed:
                          isLoading ? null : _controller.signInWithGoogle,
                    ),
                    if (isIos) ...[
                      const SizedBox(height: AppSpacing.md),
                      _SocialButton(
                        icon: Icons.apple,
                        label: 'Continue with Apple',
                        onPressed:
                            isLoading ? null : _controller.signInWithApple,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text('or', style: theme.textTheme.bodySmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SegmentedButton<_AuthMode>(
                      segments: const [
                        ButtonSegment(
                          value: _AuthMode.email,
                          label: Text('Email'),
                          icon: Icon(Icons.mail_outline),
                        ),
                        ButtonSegment(
                          value: _AuthMode.phone,
                          label: Text('Phone'),
                          icon: Icon(Icons.phone_outlined),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: isLoading
                          ? null
                          : (selection) =>
                              setState(() => _mode = selection.first),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_mode == _AuthMode.email)
                      ..._buildEmailFields()
                    else
                      _buildPhoneField(),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : (_mode == _AuthMode.email
                              ? _submitEmail
                              : _submitPhone),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Text(_primaryLabel()),
                    ),
                    if (_mode == _AuthMode.email) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(() => _isRegister = !_isRegister),
                        child: Text(
                          _isRegister
                              ? 'Have an account? Sign in'
                              : 'New here? Create an account',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _primaryLabel() {
    if (_mode == _AuthMode.phone) return 'Send code';
    return _isRegister ? 'Create account' : 'Sign in';
  }

  List<Widget> _buildEmailFields() {
    return [
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.mail_outline),
        ),
        validator: Validators.email,
      ),
      const SizedBox(height: AppSpacing.md),
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        validator: Validators.password,
        onFieldSubmitted: (_) => _submitEmail(),
      ),
    ];
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumber],
      decoration: const InputDecoration(
        labelText: 'Phone number',
        hintText: '+14155550123',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
      validator: Validators.phone,
      onFieldSubmitted: (_) => _submitPhone(),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
