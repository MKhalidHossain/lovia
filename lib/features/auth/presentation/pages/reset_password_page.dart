import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/utils/validators.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/app_text_field.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  late final Map<String, dynamic> _args =
      (Get.arguments as Map<String, dynamic>?) ?? const {};
  String get _email => _args['email'] as String? ?? '';
  String get _otp => _args['otp'] as String? ?? '';

  String? _passwordError;
  String? _confirmError;
  bool _obscure = true;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final passwordError = Validators.password(_password.text);
    final confirmError =
        Validators.confirmPassword(_confirm.text, _password.text);
    setState(() {
      _passwordError = passwordError;
      _confirmError = confirmError;
    });
    if (passwordError != null || confirmError != null) return;
    final ok = await _auth.resetPassword(
      email: _email,
      otp: _otp,
      newPassword: _password.text,
    );
    if (ok) await Get.offAllNamed<void>(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(title: const Text('New password')),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Set a new password', style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _password,
              label: 'New password',
              hint: 'At least 6 characters',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              textInputAction: TextInputAction.next,
              errorText: _passwordError,
              suffix: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _confirm,
              label: 'Confirm password',
              hint: 'Re-enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              errorText: _confirmError,
            ),
            const SizedBox(height: AppSpacing.xl),
            Obx(
              () => GradientButton(
                label: 'Reset password',
                isLoading: _auth.isBusy.value,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
